## BUDDY SYSTEM SIMPLE

# 伙伴系统的结构

使用数组来存这个完全二叉树其中父子关系为：

左孩子索引=父节点索引*2+1

右孩子索引=父节点索引*2+2

父节点索引=(子节点索引-1)/2

数组元素采用下面结构

``` C
struct memtree{
    int avail; 
    int size;
    struct Page* page;
};

struct memtree* tree;
int tree_size;
struct Page* propertypages;
```

其中`avail`为当前树下面可以分出的最大内存块;
`size`为该节点对应的内存块大小(以页为单位);
`page`为对应内存块的首个`Page`项。
全局变量包括:
`tree`为伙伴系统数组;
`tree_size`为该数组的大小。

# 简单映射函数实现

实现代码如下

``` C
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
```

其中`memmap`为找到树数组元素对应的`Page`项(内存块的开头),用于初始化树节点的`page`属性。
`getps`为确定对应树数组元素对应的内存块的大小，用于初始化树节点的`size`属性。

# 初始化伙伴系统

在初始化伙伴系统过程中，首先执行“default_fit”的初始化流程，再使用`memtree_init`函数来进行树的初始化和内存块链表的处理。

关于内存块链表的处理是考虑到buddy system希望页的数量是2的次方，但是可能硬件无法保证页的数量符合这个条件，所以要提前将块分割成多个对应的大小为2的次方的内存块，这个分割在内存块列表里体现。

`memtree_init`的处理流程为
(1) 确定树的大小，并在Page数组后面32字节对齐的位置存储树结构
(2) 自下向上初始化节点的属性，特别是`avail`属性是根据子节点来确定的，这个属性是一次分配可以分配的最大页的数量，所以要是两个子节点都是“满”的（`avail==size`）那么该节点也应该是满的。
(3) 自上向下将内存块列表按树的结构进行划分，分割出来的都是左孩子节点且其兄弟节点不是“满”的。如果自己不是“满”的则查看自己的左孩子结点，如果“满”的则按自己对应内存块的大小分出左边的相同大小的内存块，然后交给自己不“满”的兄弟节点的左孩子节点。重复这个递归操作，直到分完自己这一块后没有剩余的内存块了，停止递归。

```C

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
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),32));//在Page数组的后面，32字节对齐
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
buddy_system_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
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

```
## 获取内存块

获取内存块遵循以下流程：
(1) 计算可以从系统中获得的页的数量。由于是Buddy system,所以向上找最接近的2的次方size。进入`get_mem`函数
(2) 自上向下找，对于每个节点遵循以下规则：
1、要求选择的子节点`avail`值大于等于`size`,如果都不满足则保留位该节点，退出循环；
2、有一个满足的话，选择满足的子节点向下继续循环；
3、如果都满足，选择`avail`值较小的，大小相等选左孩子；
对于每个节点，在内存块列表对应内存块进行分割操作，分割成大小一样的两个内存块。
(3) 找到合适内存块的节点后向上遍历，更新`avail`值。
(4) 结束遍历后删除对应内存块列表中的节点。更新`nr_free`。返回对应页的地址，清理标志位Property。

```C
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
static struct Page *
buddy_system_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    int size=1;
    //向上找最接近的2的次方
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
```

## 释放内存块

主要恢复思路先将这块内存的属性处理好并放回内存块链表，再恢复先自下向上找到这个树原来取走块的节点，再从这个节点向上更新节点的`avail`值，并且将可以合并的块再内存块列表里进行合并。
其中找到原先取走块的节点方法是先找到内存块的首页`Page`项对应的树的叶子节点，向上找到对应内存块大小的节点。

```C
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
```

## 检验设置

如代码注释

```C
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
    assert(!PageReserved(p0) && !PageProperty(p0));
    assert(!PageReserved(p1) && !PageProperty(p1));
    // 再分配两个组页
    p2 = alloc_pages(1);
    p3 = alloc_pages(8);
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
    // 回收页
    free_pages(p1, 2);
    assert(PageProperty(p1));
    //检验flag
    assert(p1->ref == 0);
    free_pages(p0, 1);
    free_pages(p2, 1);
    p2 = alloc_pages(3);
    free_pages(p2, 3);
    assert((p2 + 2)->ref == 0);
    p1 = alloc_pages(129);
    free_pages(p1, 256);
    free_pages(p3, 8);
}
```