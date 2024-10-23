#include <default_pmm.h>
#include <best_fit_pmm.h>
#include <buddy_system_pmm.h>
#include <defs.h>
#include <error.h>
#include <memlayout.h>
#include <mmu.h>
#include <pmm.h>
#include <sbi.h>
#include <stdio.h>
#include <string.h>
#include <../sync/sync.h>
#include <riscv.h>

// virtual address of physical page array
struct Page *pages;
//指向 Page 结构体数组的指针，page结构体中存储有当前页面的所有信息（是否被分配，是否被写等）

// amount of physical memory (in pages)
size_t npage = 0;
//系统中可以被利用的页面总数

// the kernel image is mapped at VA=KERNBASE and PA=info.base
uint64_t va_pa_offset;
//物理内存与虚拟内存之间的偏移关系

// memory starts at 0x80000000 in RISC-V
// DRAM_BASE defined in riscv.h as 0x80000000
const size_t nbase = DRAM_BASE / PGSIZE;
// DRAM_BASE为0x80000000代表物理内存的起始位置，PGSIZE为一页的大小通常为4KB

// virtual address of boot-time page directory
uintptr_t *satp_virtual = NULL;
//页表的虚拟地址

// physical address of boot-time page directory
uintptr_t satp_physical;
//页表的物理地址

// physical memory management
const struct pmm_manager *pmm_manager;
//页管理策略的结构体,定义在pmm.h里面

static void check_alloc_page(void);

// init_pmm_manager - initialize a pmm_manager instance
static void init_pmm_manager(void) {
    pmm_manager = &buddy_system_pmm_manager;
    cprintf("memory management: %s\n", pmm_manager->name);
    pmm_manager->init();
}
//决定使用何种页面管理策略


// init_memmap - call pmm->init_memmap to build Page struct for free memory
static void init_memmap(struct Page *base, size_t n) {
    pmm_manager->init_memmap(base, n);
}
//遍历内核内存找到所有空闲的页

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    //防治中断发生进行sstatus的使能位置位
    {
        page = pmm_manager->alloc_pages(n);
    }
    local_intr_restore(intr_flag);
    //使能位恢复，使其能够处理中断
    return page;
}
//使用该函数，在操作系统中分配一定数量的内存页面

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
    }
    local_intr_restore(intr_flag);
}
//释放一定数量的内存页面


// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    //该变量用于保存当前的中断使能位
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
    }
    local_intr_restore(intr_flag);
    return ret;
}
//这个函数用于查询当前内核中有多少空闲的页面

static void page_init(void) {
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
    //虚拟地址到物理地址的偏移量

    uint64_t mem_begin = KERNEL_BEGIN_PADDR;
    //内存起始地址，即内核的开始地址0x80200000
    uint64_t mem_size = PHYSICAL_MEMORY_END - KERNEL_BEGIN_PADDR;
    //定义物理内存的大小0x80000000到0x80200000为固件内存
    uint64_t mem_end = PHYSICAL_MEMORY_END; //硬编码取代 sbi_query_memory()接口
    //物理内存的结尾0x88000000

    cprintf("physcial memory map:\n");
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
            mem_end - 1);

    uint64_t maxpa = mem_end;

    if (maxpa > KERNTOP) {
        maxpa = KERNTOP;
    }
    //确保地址不会超过上界
    extern char end[];
   
    npage = maxpa / PGSIZE;
    //kernel在end[]结束, pages是剩下的页的开始，即os的代码部分在end[]处结束，剩下的位置是我们可以分配的内存
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
    //这部分内存的首指针指向空闲页的首地址
    for (size_t i = 0; i < npage - nbase; i++) {
        SetPageReserved(pages + i);
    }
   //一开始把所有页面都设置为保留给内核使用的，之后再设置哪些页面可以分配给其他程序
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
    //指向空闲页的内存地址

    mem_begin = ROUNDUP(freemem, PGSIZE);
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
    if (freemem < mem_end) {
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
        //在这里进行初始化
    }
}






/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
    // We need to alloc/free the physical memory (granularity is 4KB or other size).
    // So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    // First we should init a physical memory manager(pmm) based on the framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    cprintf("init begin\n");
    page_init();
    cprintf("init end\n");

    // use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();

    extern char boot_page_table_sv39[];
    satp_virtual = (pte_t*)boot_page_table_sv39;
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
    cprintf("check_alloc_page() succeeded!\n");
}
