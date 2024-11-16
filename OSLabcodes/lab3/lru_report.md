# LRU 算法

LRU（Least Recently Used）页面置换算法是一种常用的内存管理策略，其核心思想是淘汰最长时间未被访问的页面。这种算法基于一个简单的假设：如果一个页面最近被访问过，那么它在未来被访问的概率更高。因此，当内存满时，LRU算法会选择驱逐那些最久未被访问的页面，以腾出空间给新页面。

实现LRU算法的基本思路如下：

1. **维护一个有序链表**：我们使用一个双向链表来维护所有页面的访问顺序。链表的头部（最近使用的页面）是最频繁访问的页面，而链表的尾部（最久未使用的页面）则是接下来可能被置换的页面。

2. **页面访问处理**：每当一个页面被访问时，我们首先检查该页面是否已经在链表中：
   - 如果页面**不存在**于链表中，说明发生了缺页，我们需要将该页面添加到链表的头部，并检查内存是否已满。如果内存已满，我们需要从链表尾部移除一个页面，然后将新页面插入头部。
   - 如果页面**已存在**于链表中，我们将其移动到链表的头部，表示该页面最近被访问过。

3. **页面置换**：当内存满时，我们需要置换页面以加载新的页面。这时，我们查看链表的尾部，移除最久未使用的页面，并将其替换为新访问的页面。




## 算法实现

首先，在`_lru_init_mm`中，初始化按最近一次访问时间排序的双向的页面链表。

```c
static int 
_lru_init_mm(struct mm_struct *mm)
{
    list_init(&pra_list_head);//初始化按最近一次访问时间排序的双向的页面链表
    mm->sm_priv = &pra_list_head;//使用链表结构用于页面置换管理器
    return 0;
}
```

当需要访问某虚拟地址对应的页时，我们提供了访问页的接口函数`read_page`和`write_page`。`write_page`用于向指定的虚拟地址写入指定的数据,`read_page`用于读取指定的虚拟地址存放的数据。

```c
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
```

接下来，编写`_lru_map_swappable`来管理待替换页的链表。

每当访问一个页，需要将该页加入链表时，首先遍历链表，删除链表中的所有该页结构体(如果存在)，然后将该页的页结构体放入链表头。

```c
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
```

当需要调用`swap out`换出某页时，会调用`_lru_swap_out_victim`函数选择被替换的页。根据我们的LRU算法，会替换掉链表尾的页。

实现方法就是获取链表中的最后一个页面，从链表中删除这个页面，然后使用 `le2page` 宏得到该页面结构体，将页面结构体指针赋值给参数 `ptr_page`。

```c
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

```

## 算法测试

在ucore中，关于页面置换算法的测试，首先调用`check_swap`函数，进行了创建vma、建立页表、分配物理页、创建映射等操作。经过这些操作后，页表中存在虚拟地址0x1000、0x2000、0x30000和x4000的映射关系，且内存中最多能放四个页，也就是当访问第五个页时，如果发生缺页异常，会涉及到页面的换入和换出。 然后调用所指定的交换管理器的验证函数。在`_lru_check_swap`函数中，我们编写了测试用例：

```c
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
```



我们在`swap_init`中将交换管理器修改为所编写的LRU算法管理器(` sm = &swap_manager_lru;`)。

然后`make qemu`，终端输出如下结果(只列出与LRU测试有关的输出)：
![图 0](images/f8cb0d1098d48c0e6a43434aeb6f16d275c76aad9ab9982a8a1af0b9a32a841f.png)  



可见，我们的LRU算法能够进行预期的页面置换。
