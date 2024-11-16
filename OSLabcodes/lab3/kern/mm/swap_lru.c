#include <defs.h>
#include <riscv.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_lru.h>
#include <list.h>
//思路：
/*选择时间最长的没有被引用的页面进行替换
  使用链表结构 按照最近一次访问的时间次序排列 链表头是最近刚被使用过的页面 链表尾是最长没有被引用的页面
  每次访问一个页面 判断是否在链表中 如果存在 删除对应节点，并将其放在链表头 
                                 如果不在 直接将其添加至链表头
  缺页时 则将链表尾进行置换
*/
static list_entry_t pra_list_head; //链表头节点 存储页面的访问顺序

//初始化内存管理结构mm_struct
static int 
_lru_init_mm(struct mm_struct *mm)
{
    list_init(&pra_list_head);//初始化按最近一次访问时间排序的双向的页面链表
    mm->sm_priv = &pra_list_head;//使用链表结构用于页面置换管理器
    return 0;
}
//用于处理页面的访问，如果页面已经在链表中，则将其移动到链表头部（表示最近被访问过）。
//                  如果不在链表中，则直接添加到链表头部。
static int _lru_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head = (list_entry_t *)mm->sm_priv;//从内存管理结构 mm_struct 中获取链表头
    list_entry_t *entry = &(page->pra_page_link);//从page中获取要处理的页面 page 的链表项 pra_page_link。
    assert(entry != NULL && head != NULL);//确保 entry 和 head 都不是空指针
    //for循环判断是否已经在链表中
    for (list_entry_t *tmp = head->next; tmp != head; tmp = tmp->next) {
        if (tmp == entry) {
            // 找到对应的页面项，从链表中删除
            list_del(tmp);
            break; // 找到后即退出循环
        }
    }
    //不在或者然后 将其加在链表头
    list_add(head, entry);
    return 0;
}
//这个函数用于选择一个页面进行置换，它会选择链表尾部的页面即最长时间未被访问的页面，并将其返回。
static int _lru_swap_out_victim(struct mm_struct *mm, struct Page **ptr_page, int in_tick)
{
    list_entry_t *head = (list_entry_t *)mm->sm_priv;//从内存管理结构 mm_struct 中获取链表头
    assert(head != NULL);//确保 head 都不是空指针
    assert(in_tick == 0);

    list_entry_t *entry = list_prev(head);//使用 list_prev 函数获取链表头的前一个元素，即链表尾部的页面项。
    if (entry != head)
    {
        list_del(entry);//从链表中删除链表尾部的页面项 entry
        *ptr_page = le2page(entry, pra_page_link);//将链表项转换回页面结构，并将其地址赋值给 ptr_page 指针指向的变量
    }
    else//空链表的情况
    {
        *ptr_page = NULL;
    }
    return 0;
}

//向指定的虚拟地址写入指定的数据
static void write_page(struct mm_struct *mm, unsigned char *a, unsigned char b)
{
    pte_t *ptep = get_pte(mm->pgdir, (uintptr_t)a, 0);//使用get_pte函数获取内存地址为a的页表项
    // 没有异常时，访问需要加链
    if ((ptep != NULL) && (*ptep & PTE_V))//检查PTE_V是否被设置，当页表项存在且有效时 说，明改地址已映射到屋里内存 执行
    {
        struct Page *page = pte2page(*ptep);//使用pte2page函数将页表项转换为指向物理页面的结构体指针page
        _lru_map_swappable(mm, (uintptr_t)a, page, 1);//调用_lru_map_swappable 函数，将页面标记为可交换
    }
    *a = b;//修改页面链表
}

static unsigned char read_page(struct mm_struct *mm, unsigned char *a)
{
    pte_t *ptep = get_pte(mm->pgdir, (uintptr_t)a, 0);//使用get_pte函数获取内存地址为a的页表项
    if ((ptep != NULL) && (*ptep & PTE_V))//检查PTE_V是否被设置，当页表项存在且有效时 说，明改地址已映射到屋里内存 执行
    {
        struct Page *page = pte2page(*ptep);//使用pte2page函数将页表项转换为指向物理页面的结构体指针page
        _lru_map_swappable(mm, (uintptr_t)a, page, 1);//调用_lru_map_swappable 函数，将页面标记为可交换
    }
    return *(unsigned char *)a;
}

static int
_lru_check_swap(void)
{
    cprintf("write Virt Page c in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x3000, 0x0c);
    assert(pgfault_num == 4);
    cprintf("write Virt Page a in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x1000, 0x0a);
    assert(pgfault_num == 4);
    cprintf("write Virt Page d in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x4000, 0x0d);
    assert(pgfault_num == 4);
    cprintf("write Virt Page b in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x2000, 0x0b);
    assert(pgfault_num == 4);
    cprintf("write Virt Page e in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x5000, 0x0e);
    assert(pgfault_num == 5); // 替换3
    cprintf("write Virt Page b in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x2000, 0x0b);
    assert(pgfault_num == 5);
    cprintf("write Virt Page a in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x1000, 0x0a);
    assert(pgfault_num == 5);
    cprintf("write Virt Page c in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x3000, 0x0c);
    assert(pgfault_num == 6); // 替换4
    cprintf("write Virt Page d in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x4000, 0x0d);
    assert(pgfault_num == 7); // 替换5
    cprintf("write Virt Page b in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x2000, 0x0b);
    assert(pgfault_num == 7);
    cprintf("write Virt Page e in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x5000, 0x0e);
    assert(pgfault_num == 8); // 替换 1
    cprintf("write Virt Page a in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x1000, 0x0a);
    assert(pgfault_num == 9); // 替换3

    assert(read_page(check_mm_struct, (unsigned char *)0x3000) == 0x0c);
    assert(pgfault_num == 10); // 替换4
    assert(read_page(check_mm_struct, (unsigned char *)0x2000) == 0x0b);
    assert(pgfault_num == 10);
    assert(read_page(check_mm_struct, (unsigned char *)0x4000) == 0x0d);
    assert(pgfault_num == 11); // 替换5
    cprintf("write Virt Page a in lru_check_swap\n");
    write_page(check_mm_struct, (unsigned char *)0x1000, 0x0a);
    assert(pgfault_num == 11);
    return 0;
}

static int _lru_init(void)
{
    return 0;
}

static int _lru_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int _lru_tick_event(struct mm_struct *mm)
{
    return 0;
}

struct swap_manager swap_manager_lru =
    {
        .name = "lru swap manager",
        .init = &_lru_init,
        .init_mm = &_lru_init_mm,
        .tick_event = &_lru_tick_event,
        .map_swappable = &_lru_map_swappable,
        .set_unswappable = &_lru_set_unswappable,
        .swap_out_victim = &_lru_swap_out_victim,
        .check_swap = &_lru_check_swap,
};