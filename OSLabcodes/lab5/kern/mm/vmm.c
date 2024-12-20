#include <vmm.h>
#include <sync.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <error.h>
#include <pmm.h>
#include <riscv.h>
#include <swap.h>
#include <kmalloc.h>

/* 
  虚拟内存管理（vmm）的设计包含两个部分：mm_struct（mm）和 vma_struct（vma）。
  mm 是用于管理一组连续虚拟内存区域的内存管理器，这些虚拟内存区域共享相同的页目录表（PDT）。
  vma 是一个连续的虚拟内存区域。
  在 mm 中使用线性链表和红黑树来管理 vma。
---------------
  与 mm 相关的函数：
   全局函数：
     struct mm_struct * mm_create(void) 
       // 创建一个新的 mm 实例
     void mm_destroy(struct mm_struct *mm)
       // 销毁一个 mm 实例并释放其资源
     int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr)
       // 处理页面错误（Page Fault）
--------------
  与 vma 相关的函数：
   全局函数：
     struct vma_struct * vma_create (uintptr_t vm_start, uintptr_t vm_end,...)
       // 创建一个新的 vma 实例，定义虚拟内存区域的起始和结束地址
     void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
       // 将一个 vma 插入到 mm 中的管理结构中
     struct vma_struct * find_vma(struct mm_struct *mm, uintptr_t addr)
       // 在 mm 中查找包含给定地址 addr 的 vma
   局部函数：
     inline void check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
       // 检查两个 vma 是否有地址重叠
---------------
   校验正确性的函数：
     void check_vmm(void);
       // 检查虚拟内存管理模块的正确性
     void check_vma_struct(void);
       // 检查 vma 结构的正确性
     void check_pgfault(void);
       // 检查页面错误处理机制的正确性
*/


static void check_vmm(void);
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));

    if (mm != NULL) {
        list_init(&(mm->mmap_list));
        mm->mmap_cache = NULL;
        mm->pgdir = NULL;
        mm->map_count = 0;

        if (swap_init_ok) swap_init_mm(mm);
        else mm->sm_priv = NULL;
        
        set_mm_count(mm, 0);
        lock_init(&(mm->mm_lock));
    }    
    return mm;
}

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));

    if (vma != NULL) {
        vma->vm_start = vm_start;
        vma->vm_end = vm_end;
        vma->vm_flags = vm_flags;
    }
    return vma;
}


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
    struct vma_struct *vma = NULL;
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
                    vma = le2vma(le, list_link);
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
                    vma = NULL;
                }
        }
        if (vma != NULL) {
            mm->mmap_cache = vma;
        }
    }
    return vma;
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
}


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
    }
    if (le_next != list) {
        check_vma_overlap(vma, le2vma(le_next, list_link));
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
}

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
    mm=NULL;
}

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
    //将地址对齐
    if (!USER_ACCESS(start, end)) {
        return -E_INVAL;
    }
    //检查地址范围
    assert(mm != NULL);

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
        goto out;
    }
    ret = -E_NO_MEM;
    //检查地址是否重叠
    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
        goto out;
    }
    insert_vma_struct(mm, vma);
    if (vma_store != NULL) {
        *vma_store = vma;
    }
    //插入新创建的vma到vm_struct管理结构
    ret = 0;

out:
    return ret;
}

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    //源进程与目的进程的虚拟地址分布情况
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    //获取父进程的虚拟地址块分布链表
    while ((le = list_prev(le)) != list) {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
        //遍历父进程的所有vma块并将其复制给nvma
        if (nvma == NULL) {
            return -E_NO_MEM;
        }
        //地址空间不够则报错
        insert_vma_struct(to, nvma);
       //否则插入到子进程内存管理链表中
        bool share = 1;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
}

void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
        //先解除虚拟地址到物理内存的映射
    }
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
        //在释放物理内存，即释放页表
    }
}

bool
copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable) {
    if (!user_mem_check(mm, (uintptr_t)src, len, writable)) {
        return 0;
    }
    memcpy(dst, src, len);
    return 1;
}
//从用户态拷贝数据到内核态
bool
copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len) {
    if (!user_mem_check(mm, (uintptr_t)dst, len, 1)) {
        return 0;
        //进行内存有效性检验与权限检验
    }
    memcpy(dst, src, len);
    return 1;
}
//从内核态拷贝数据到用户态

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
    check_vmm();
}

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
    // size_t nr_free_pages_store = nr_free_pages();
    
    check_vma_struct();
    check_pgfault();

    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void) {
    // size_t nr_free_pages_store = nr_free_pages();

    struct mm_struct *mm = mm_create();
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
        assert(le != &(mm->mmap_list));
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
        struct vma_struct *vma1 = find_vma(mm, i);
        assert(vma1 != NULL);
        struct vma_struct *vma2 = find_vma(mm, i+1);
        assert(vma2 != NULL);
        struct vma_struct *vma3 = find_vma(mm, i+2);
        assert(vma3 == NULL);
        struct vma_struct *vma4 = find_vma(mm, i+3);
        assert(vma4 == NULL);
        struct vma_struct *vma5 = find_vma(mm, i+4);
        assert(vma5 == NULL);

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
        struct vma_struct *vma_below_5= find_vma(mm,i);
        if (vma_below_5 != NULL ) {
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
}

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();

    check_mm_struct = mm_create();
    assert(check_mm_struct != NULL);

    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
    assert(pgdir[0] == 0);

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
    assert(vma != NULL);

    insert_vma_struct(mm, vma);

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;

    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
        sum -= *(char *)(addr + i);
    }

    assert(sum == 0);

    pde_t *pd1=pgdir,*pd0=page2kva(pde2page(pgdir[0]));
    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    pgdir[0] = 0;
    flush_tlb();

    mm->pgdir = NULL;
    mm_destroy(mm);
    check_mm_struct = NULL;

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_pgfault() succeeded!\n");
}
//page fault number
volatile unsigned int pgfault_num=0;

/* do_pgfault - 中断处理函数，用于处理页面异常（page fault）
 * @mm         : 表示使用相同页目录表（PDT）的一组虚拟内存区域（vma）的管理结构
 * @error_code : 记录在 trapframe->tf_err 中的错误代码，由 x86 硬件设置
 * @addr       : 引发内存访问异常的地址（即 CR2 寄存器的内容）
 *
 * 调用关系图：trap --> trap_dispatch --> pgfault_handler --> do_pgfault
 * 处理器通过两项信息提供给 uCore 的 do_pgfault 函数，以帮助诊断异常并从中恢复：
 *   (1) CR2 寄存器的内容：处理器会将 CR2 寄存器加载为产生异常的32位线性地址。
 *       do_pgfault 函数可以利用此地址定位对应的页目录项和页表项。
 *   (2) 栈上的错误代码：页面异常的错误代码格式不同于其他异常。错误代码包含以下三项信息：
 *         -- P 标志位（bit 0）：指示异常是由于页面不存在（0）还是由于访问权限违规或使用了保留位（1）。
 *         -- W/R 标志位（bit 1）：指示导致异常的内存访问是读操作（0）还是写操作（1）。
 *         -- U/S 标志位（bit 2）：指示发生异常时处理器是在用户模式（1）还是内核模式（0）下运行。
 */

int do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr)
{   //addr触发缺页的虚拟地址
    int ret = -E_INVAL;
    // try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
   //查找虚拟内存区域
    pgfault_num++;
    // If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr)
    {
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
        goto failed;
        //无效addr
    }

    /* IF (write an existed addr ) OR
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    //初始权限：用户模式可访问
    if (vma->vm_flags & VM_WRITE)
    {
        perm |= READ_WRITE;
    }
    //如果vma支持写入（VM_WRITE），则额外设置写权限
    addr = ROUNDDOWN(addr, PGSIZE);

    ret = -E_NO_MEM;

    pte_t *ptep = NULL;

    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
    {
        //尝试获取到这个页表项
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }

    if (*ptep == 0)
    { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL)
        {
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
            goto failed;
        }
        //为虚拟地址分配一个物理页面
    }
    else
    {
        /*LAB3 EXERCISE 3: YOUR CODE
         * 请你根据以下信息提示，补充函数
         * 现在我们认为pte是一个交换条目，那我们应该从磁盘加载数据并放到带有phy addr的页面，
         * 并将phy addr与逻辑addr映射，触发交换管理器记录该页面的访问情况
         *
         *  一些有用的宏和定义，可能会对你接下来代码的编写产生帮助(显然是有帮助的)
         *  宏或函数:
         *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
         *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
         *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
         *    swap_map_swappable ： 设置页面可交换
         */
        struct Page *page = NULL;
        // 如果试图写入只读页面
        if ((*ptep & PTE_V))
        {
            // 只读物理页
            page = pte2page(*ptep);
            // 如果该物理页面被多个进程引用
            if (page_ref(page) > 1 && (*ptep & PTE_COW))
            {
                // 分配页面并设置新地址映射
                // pgdir_alloc_page -> alloc_page()  page_insert()
                cprintf("COW %x: ptep 0x%x, pte 0x%x,物理页0x%x\n",page_ref(page), ptep, *ptep, page2pa(pte2page(*ptep)));
                //设置另外的进程也为
                //page_insert(mm->pgdir, page, addr, perm);
                struct Page *newPage = pgdir_alloc_page(mm->pgdir, addr, perm);
                void *kva_src = page2kva(page);
                void *kva_dst = page2kva(newPage);
                // 拷贝数据
                memcpy(kva_dst, kva_src, PGSIZE);
                page_ref_dec(page);//减少一个共享者
            }   
            // 如果该物理页面只被当前进程所引用
            else if(page_ref(page) == 1 && (*ptep & PTE_COW))
            { 
                cprintf("COW %x: ptep 0x%x, pte 0x%x,物理页0x%x\n",page_ref(page), ptep, *ptep, page2pa(pte2page(*ptep)));
                // page_insert，保留当前物理页，重设其PTE权限
                page_insert(mm->pgdir, page, addr, perm);
            }
            else
            {
            cprintf("error!\n");
            }
        }
        else
        {
            if (swap_init_ok)
            {
                //(1）According to the mm AND addr, try to load the content of right disk page into the memory which page managed.
                if ((ret = swap_in(mm, addr, &page) != 0))
                {
                    goto failed;
                }

                page_insert(mm->pgdir, page, addr, perm);
            }
            else
            {
                cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
                goto failed;
            }
        }
        // 当前缺失的页已经加载回内存中，所以设置当前页为可swap。
        swap_map_swappable(mm, addr, page, 1);
        page->pra_vaddr = addr;
    }
    ret = 0;
failed:
    return ret;
}
// 确定引发页面缺失的虚拟地址是否合法，并找到对应的虚拟内存区域（VMA）。
// 根据虚拟地址，获取或创建页表项（PTE）。
// 根据页表项的状态处理页面缺失：
// 若页面未映射，分配新页面。
// 若页面有效但只读，触发写时复制（COW）。
// 若页面在交换空间，加载页面数据并建立映射。
// 标记页面可交换。
// 返回处理结果，成功为0，失败返回对应错误代码。

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
    if (mm != NULL) {
        if (!USER_ACCESS(addr, addr + len)) {
            return 0;
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while (start < end) {
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
                return 0;
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK)) {
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}

