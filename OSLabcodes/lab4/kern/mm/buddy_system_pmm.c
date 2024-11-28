#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_system_pmm.h>
#include <stdio.h>
//#include <stdlib.h>

/* In the first fit algorithm, the allocator keeps a list of free blocks (known as the free list) and,
   on receiving a request for memory, scans along the list for the first block that is large enough to
   satisfy the request. If the chosen block is significantly larger than that requested, then it is 
   usually split, and the remainder added to the list as another free block.
   Please see Page 196~198, Section 8.2 of Yan Wei Min's chinese book "Data Structure -- C programming language"
*/

// you should rewrite functions: default_init,default_init_memmap,default_alloc_pages, default_free_pages.
/*
 * Details of FFMA
 * (1) Prepare: In order to implement the First-Fit Mem Alloc (FFMA), we should manage the free mem block use some list.
 *              The struct free_area_t is used for the management of free mem blocks. At first you should
 *              be familiar to the struct list in list.h. struct list is a simple doubly linked list implementation.
 *              You should know howto USE: list_init, list_add(list_add_after), list_add_before, list_del, list_next, list_prev
 *              Another tricky method is to transform a general list struct to a special struct (such as struct page):
 *              you can find some MACRO: le2page (in memlayout.h), (in future labs: le2vma (in vmm.h), le2proc (in proc.h),etc.)
 * (2) default_init: you can reuse the  demo default_init fun to init the free_list and set nr_free to 0.
 *              free_list is used to record the free mem blocks. nr_free is the total number for free mem blocks.
 * (3) default_init_memmap:  CALL GRAPH: kern_init --> pmm_init-->page_init-->init_memmap--> pmm_manager->init_memmap
 *              This fun is used to init a free block (with parameter: addr_base, page_number).
 *              First you should init each page (in memlayout.h) in this free block, include:
 *                  p->flags should be set bit PG_property (means this page is valid. In pmm_init fun (in pmm.c),
 *                  the bit PG_reserved is setted in p->flags)
 *                  if this page  is free and is not the first page of free block, p->property should be set to 0.
 *                  if this page  is free and is the first page of free block, p->property should be set to total num of block.
 *                  p->ref should be 0, because now p is free and no reference.
 *                  We can use p->page_link to link this page to free_list, (such as: list_add_before(&free_list, &(p->page_link)); )
 *              Finally, we should sum the number of free mem block: nr_free+=n
 * (4) default_alloc_pages: search find a first free block (block size >=n) in free list and reszie the free block, return the addr
 *              of malloced block.
 *              (4.1) So you should search freelist like this:
 *                       list_entry_t le = &free_list;
 *                       while((le=list_next(le)) != &free_list) {
 *                       ....
 *                 (4.1.1) In while loop, get the struct page and check the p->property (record the num of free block) >=n?
 *                       struct Page *p = le2page(le, page_link);
 *                       if(p->property >= n){ ...
 *                 (4.1.2) If we find this p, then it' means we find a free block(block size >=n), and the first n pages can be malloced.
 *                     Some flag bits of this page should be setted: PG_reserved =1, PG_property =0
 *                     unlink the pages from free_list
 *                     (4.1.2.1) If (p->property >n), we should re-caluclate number of the the rest of this free block,
 *                           (such as: le2page(le,page_link))->property = p->property - n;)
 *                 (4.1.3)  re-caluclate nr_free (number of the the rest of all free block)
 *                 (4.1.4)  return p
 *               (4.2) If we can not find a free block (block size >=n), then return NULL
 * (5) default_free_pages: relink the pages into  free list, maybe merge small free blocks into big free blocks.
 *               (5.1) according the base addr of withdrawed blocks, search free list, find the correct position
 *                     (from low to high addr), and insert the pages. (may use list_next, le2page, list_add_before)
 *               (5.2) reset the fields of pages, such as p->ref, p->flags (PageProperty)
 *               (5.3) try to merge low addr or high addr blocks. Notice: should change some pages's p->property correctly.
 */
free_area_t bsfree_area;


//buddy sys code by 2212225

#define free_list (bsfree_area.free_list)
#define nr_free (bsfree_area.nr_free)

struct memtree{
    int avail; 
    int size;
    struct Page* page;
};

struct memtree* tree;
int tree_size;
struct Page* propertypages;

struct Page* memmap(struct Page *base, int pos)
{
    if(pos>=tree_size)return NULL;
    int floorpw=0;
    int block_size=(tree_size+1)/2;
    while(pos >=floorpw*2 + 1)
    {
        block_size/=2;
        floorpw*=2;
        floorpw+=1;
    }
    (struct Page*)(base + (pos-floorpw) * block_size);
    return (struct Page*)(base + (pos-floorpw) * block_size);
}
int getps(int pos)
{
    if(pos>=tree_size)return 0;
    int floorpw=0;
    int block_size=(tree_size+1)/2;
    while(pos >=floorpw*2 + 1)
    {
        block_size/=2;
        floorpw*=2;
        floorpw+=1;
    }
    return block_size;
}

void memtree_init(struct Page *base, int np)
{
    //初始化树

    //构建树
    int size=1;
    while(np>size)
	{
		size=size<<1;	
	} 
    tree_size=2*size-1;
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),4));//在Page数组的后面，32字节对齐
    for(int i=tree_size - 1;i>=0;i--)//自下到上
    {
        tree[i].page=memmap(base,i);//初始化page
        tree[i].size=getps(i);//初始化size
        if(i>=size-1)
        {   
            tree[i].avail=(i-size+1<np)?1:0;//叶子节点对应的是一个页，判断是不是属于可分配内存块
        }
        else{//根据孩子节点的属性来初始化
            if(tree[i*2+1].avail+tree[i*2+2].avail==tree[i].size)
            {
                tree[i].avail=tree[i].size;
            }
            else{
                tree[i].avail=(tree[i*2+1].avail>tree[i*2+2].avail) ?  tree[i*2+1].avail: tree[i*2+2].avail;
            }
            
        }
    }

    //处理内存块链表
    if(np==size)//这意味着刚好页的数量是2的次方
    {
        return;
    }
    int pos=1;
    while(pos<np)//向左偏的
    {
        if(tree[pos].avail==tree[pos].size){//这个地方满了则分出来（都是左孩子），剩下的交由兄弟结点的子节点来里处理内存块链表
            if(tree[pos].page->property==tree[pos].size)
            {
                break;
            }
            //分割
            tree[pos+1].page->property=tree[pos].page->property-tree[pos].size;
            tree[pos].page->property=tree[pos].size;
            SetPageProperty(tree[pos].page);
            //加入全新的两个链表
            list_add(&(tree[pos].page->page_link),&(tree[pos+1].page->page_link));
            pos+=1;//换到兄弟节点
            assert(tree[pos].avail<tree[pos].size);
            pos=pos*2+1;//换到兄弟结点的左孩子
            continue;
        }
        else{
            pos=pos*2+1;//发现不满，给自己的左孩子
            continue;
        }
        
    }
}

struct Page* get_mem(int n)
{
    int pos;
    int find_pos=0;
    //自上向下找
    while(tree[find_pos].avail>=n && find_pos<(tree_size-1)/2)
    {
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)//处理内存块链表
        {
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
            SetPageProperty(tree[find_pos*2+2].page);
            list_add(&(tree[find_pos*2+1].page->page_link), &((tree[find_pos*2+2].page)->page_link));
        }
        if(tree[find_pos*2+1].avail>=n && (tree[find_pos*2+2].avail >= tree[find_pos*2+1].avail || tree[find_pos*2+2].avail<n))//选择左孩子的情况
        {
            find_pos=find_pos*2+1;
            continue;
        }
        if(tree[find_pos*2+2].avail>=n)//选择右孩子
        {
            find_pos=find_pos*2+2;
            continue;
        }
        //选择自己并退出的情况
        break;
    }
    if(find_pos==0&&tree[find_pos].avail<n)
    {
        return NULL;
    }
    //设置为这个地方内存块已经被用了
    tree[find_pos].avail=0;
    pos=find_pos;
    //跟新avail值
    while(pos>0)
    {
        int dpos=(pos-1)/2;
        //选子节点最大值，因为这条路径下来，父节点不可能是完整的
        tree[dpos].avail=tree[dpos*2+1].avail>tree[dpos*2+2].avail ? tree[dpos*2+1].avail:tree[dpos*2+2].avail;
        pos=dpos;
    }
    //删除内存块列表对应节点
    list_del(&(tree[find_pos].page->page_link));
    nr_free -= n;
    return tree[find_pos].page;
}


void free_mem(struct Page* page,size_t n)//处理合并问题以及树的更新 
{
    //找到对应起始页的leaf节点 
    int ea= page-tree[0].page;
    int pos=ea+(tree_size-1)/2;

    // 找到原来被设为0的节点 
    while(pos>0)
    {
        if (tree[pos].size>=n)break;
        pos=(pos-1)/2;
    }//pos is the found node
    //恢复 
    tree[pos].avail=tree[pos].size;
    //向上遍历如果可合并则合并，不行则bu合并
    while(pos>0)
    {
        int dpos=(pos-1)/2;
        if(tree[dpos*2+1].avail+tree[dpos*2+2].avail==tree[dpos].size)//遇到可以合并的就合并
        {
            
            //考虑链表的合并 
            assert(tree[dpos*2+2].page->property==tree[dpos*2+2].size);
            assert(tree[dpos*2+1].page->property==tree[dpos*2+1].size);
            tree[dpos].avail=tree[dpos].size;
            tree[dpos].page->property=tree[dpos].size;
            ClearPageProperty(tree[dpos*2+2].page);
            list_del(&(tree[dpos*2+2].page->page_link));
            //tree[dpos*2+2].page->property=0;
        }
        else//没法合并就选最大的 
        {
            tree[dpos].avail=tree[dpos*2+1].avail>tree[dpos*2+2].avail ? tree[dpos*2+1].avail:tree[dpos*2+2].avail;
        }
        pos=dpos;
    }
    return;
}



static void
buddy_system_init(void) {
    list_init(&free_list);
    nr_free = 0;
}

static void
buddy_system_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    propertypages = base;
    for (; p != base + n; p ++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link));
    } else {
        list_entry_t* le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }

        }
    }
    memtree_init(base,n);
    
}

static struct Page *
buddy_system_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    int size=1;
    while(n>size)
	{
		size=size<<1;	
	} 
    page=get_mem(size);
    if (page != NULL) {
        ClearPageProperty(page);
    }
    return page;
}

static void
buddy_system_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    int size=1;
    while(n>size)
	{
		size=size<<1;	
	} 
    for (; p != base + size; p ++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property=size;
    SetPageProperty(base);
    nr_free += size;
    //找到对应位置并插入 
    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link));
    } else {
        list_entry_t* le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }
        }
    }
    //处理好树和链表
    free_mem(base,size);
    return;
}

static size_t
buddy_system_nr_free_pages(void) {
    return nr_free;
}

static void
basic_check(void) {
    struct Page *p0, *p1, *p2;
    cprintf("%d\n",nr_free);
    size_t nr_s=nr_free;
    p0 = p1 = p2 = NULL;
    assert((p0 = alloc_pages(4)) != NULL);
    cprintf("%d\n",nr_free);
    assert((p1 = alloc_page()) != NULL);
    cprintf("%d\n",nr_free);
    assert((p2 = alloc_page()) != NULL);
    cprintf("%d\n",nr_free);
    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);

    //list_entry_t free_list_store = free_list;
    //list_init(&free_list);
    //assert(list_empty(&free_list));

    //unsigned int nr_free_store = nr_free;
    //nr_free = 0;

    //assert(alloc_page() == NULL);

    free_pages(p0,4);
    free_page(p1);
    free_page(p2);
    cprintf("%d\n",nr_free);
    assert(nr_free == nr_s);
    //assert(nr_free == 3);

    //assert((p0 = alloc_page()) != NULL);
    //assert((p1 = alloc_page()) != NULL);
    //assert((p2 = alloc_page()) != NULL);

    //assert(alloc_page() == NULL);

    //free_page(p0);
    //assert(!list_empty(&free_list));

    //struct Page *p;
    //assert((p = alloc_page()) == p0);tree[find_pos*2+2].avail>=n

    //assert(nr_free == 0);
    //free_list = free_list_store;
    //nr_free = nr_free_store;

    //free_page(p);
    //free_page(p1);
    //free_page(p2);
}

// LAB2: below code is used to check the best fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
buddy_system_check(void) {
    int all_pages = nr_free_pages();
    struct Page* p0, *p1, *p2, *p3;
    // 分配过大的页数
    assert(alloc_pages(all_pages + 1) == NULL);
    // 分配两个组页

    //在实验里发现了可分配page数量不是2的次方
    //这里是验证是不是正确选择了合适的页
    //因为不是2的次方，根据分配策略p0较小应该是在后面的内存块，而p1是在最前面的
    //如果没有成功执行策略，p1无法获得内存，因为p0的分配分割了第二层左孩子结点对应的内存块，而没有能满足p1大小的内存块。
    p0 = alloc_pages(1);
    assert(p0 != NULL);
    p1 = alloc_pages(all_pages/2);
    assert(p1 != NULL);
    assert(p1 == propertypages);
    free_pages(p1, all_pages/2);
    //重新分配p1
    p1 = alloc_pages(2);
    //free_pages(p1, 2);
    //assert(p1 == p0 + 2);
    assert(!PageReserved(p0) && !PageProperty(p0));
    assert(!PageReserved(p1) && !PageProperty(p1));
    // 再分配两个组页
    p2 = alloc_pages(1);
    //assert(p2 == p0 + 1);
    p3 = alloc_pages(8);
    //assert(p3 == p0 + 8);
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
    // 回收页
    free_pages(p1, 2);
    assert(PageProperty(p1));
    assert(p1->ref == 0);
    free_pages(p0, 1);
    free_pages(p2, 1);
    // 回收后再分配
    p2 = alloc_pages(3);
    //assert(p2 == p0);
    free_pages(p2, 3);
    assert((p2 + 2)->ref == 0);
    //assert(nr_free_pages() == all_pages >> 1);
    p1 = alloc_pages(129);
    //(p1 == p0 + 256);
    free_pages(p1, 256);
    free_pages(p3, 8);
}
//这个结构体在
const struct pmm_manager buddy_system_pmm_manager = {
    .name = "buddy_system_pmm_manager",
    .init = buddy_system_init,
    .init_memmap = buddy_system_init_memmap,
    .alloc_pages = buddy_system_alloc_pages,
    .free_pages = buddy_system_free_pages,
    .nr_free_pages = buddy_system_nr_free_pages,
    .check = buddy_system_check,
};

