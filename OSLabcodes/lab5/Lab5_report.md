## 练习 0：填写已有实验
>本实验依赖实验2/3/4。请把你做的实验2/3/4的代码填入本实验中代码中有“LAB2”/“LAB3”/“LAB4”的注释相应部分。注意：为了能够正确执行lab5的测试应用程序，可能需对已完成的实验2/3/4的代码进行进一步改进。

由于Lab5在进程控制块`proc_sturct`中加入了`exit_code`、`wait_state`以及标识线程之间父子关系的链表节点`*cptr`, `*yptr`, `*optr`。

```c
// kern/process/proc.h
int exit_code;   // 退出码，当前线程退出时的原因(在回收子线程时会发送给父线程)
uint32_t wait_state;  // 等待状态
// cptr即child ptr，当前线程子线程(链表结构)
// yptr即younger sibling ptr；
// optr即older sibling ptr;
// cptr为当前线程的子线程双向链表头结点，通过yptr和optr可以找到关联的所有子线程
struct proc_struct *cptr, *yptr, *optr; // 进程之间的关系
```

因此，分配进程控制块的`alloc_proc`函数有所改变：

```c
// 新增的两行
proc->wait_state = 0;  // PCB 新增的条目，初始化进程等待状态
proc->cptr = proc->optr = proc->yptr = NULL; //指针初始化
```

而在`do_fork`函数中，还需要设置进程之间的关系，直接调用`set_links`函数即可。

```c
// do_fork 函数新增
set_links(proc);  // 设置进程链接
```

`set_links`函数将进程加入进程链表，设置进程关系，并将`nr_process`加1。

```c
static void set_links(struct proc_struct *proc) {
    list_add(&proc_list,&(proc->list_link)); // 进程加入进程链表
    proc->yptr = NULL;  // 当前进程的 younger sibling 为空
    if ((proc->optr = proc->parent->cptr) != NULL) {
        proc->optr->yptr = proc;  // 当前进程的 older sibling 为当前进程
    }
    proc->parent->cptr = proc;  // 父进程的子进程为当前进程
    nr_process ++;  //进程数加一
}
```

## 练习 1：加载应用程序并执行（需要编码）

> **do_execv**函数调用`load_icode`（位于kern/process/proc.c中）来加载并解析一个处于内存中的ELF执行文件格式的应用程序。你需要补充`load_icode`的第6步，建立相应的用户内存空间来放置应用程序的代码段、数据段等，且要设置好`proc_struct`结构中的成员变量trapframe中的内容，确保在执行此进程后，能够从应用程序设定的起始执行地址开始执行。需设置正确的trapframe内容。
> 1.请在实验报告中简要说明你的设计实现过程。
> 2.请简要描述这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。

### （一）设计实现过程

`load_icode`的六步工作内容如下：
- 第一步：为当前进程创建一个新的 `mm` 结构
- 第二步：创建一个新的页目录表`PDT`，并将` mm->pgdir `设置为页目录表的内核虚拟地址。
- 第三步：读取`ELF`格式，检验其合法性，循环读取每一个程序段，将需要加载的段加载到内存中，设置相应段的权限。之后初始化`BSS`段，将其清零。
- 第四步：构建用户栈内存
- 第五步： 设置当前进程的 `mm`、`sr3`，并设置 `CR3` 寄存器为页目录表的物理地址
- 第六步：设置`trapframe`，将`gnr.sp`指向用户栈顶，将`epc`设置为`ELF`文件的入口地址，设置`sstatus`寄存器，将`SSSTATUS_SPP`位置 0，表示退出当前中断后进入用户态，将 `SSSTATUS_SPIE`位置 1，表示退出当前中断后开启中断。

    -  `tf->gpr.sp`：用户进程的栈指针。每个用户进程会有两个栈，一个内核栈一个用户栈，在这里我们使用`kern\mm\memlayout.h`中的宏定义`USTACKTOP`即用户栈的顶部赋值给sp寄存器。
    -  `tf->epc`：用户程序的入口点。在`ELF`格式中，文件头部的结构体`elfhdr`中有一个字段`e_entry`表示可执行文件的入口点，我们将其赋值给`epc`作为用户程序的入口点。
    -  `tf->status`：用户程序中需要修改status寄存器的`SPP`位与`SPIE`位。`SPP`记录的是在中断之前处理器的特权级别，0表示`U-Mode`，1表示`S-Mode`。`SPIE`位记录的是在中断之前中断是否开启，0表示中断开启，1表示中断关闭。我们的目的是让CPU进入`U_mode`执行`do_execve()`加载的用户程序，在返回时要通过`SPP`位回到用户模式，因此需要把`SSTATUS_SPP`置0。默认中断返回后，用户态执行时是开中断的，因此`SPIE`位也要置零。总结来说我们需要把保留的中断前的寄存器`sstatus`中的`SSTATUS_SPP`以及`SSTATUS_SPIE`位清零。

最终我们编写的代码如下：

```C
tf->gpr.sp = USTACKTOP;//设置用户态的栈顶指针  
tf->epc = elf->e_entry;//设置系统调用中断返回后执行的程序入口为elf头中设置的e_entry
tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);//设置sstatus寄存器清零SSTATUS_SPP位和SSTATUS_SPIE位
```

### （二）过程简述

本实验中第一个用户进程是由第"1"个内核线程`initproc`，通过把应用程序执行码覆盖到`initproc`的用户虚拟内存空间来创建的。

（1）`kern\process\proc.c\init_main`中使用`kernel_thread`函数创建了一个子线程`user_main`。内核线程`initproc`在创建完成用户态进程后调用了`do_wait`函数，`do_wait`检测到存在`RUNNABLE`的子进程后，调用`schedule`函数。
```c
static int init_main(void *arg) {
    //......
    int pid = kernel_thread(user_main, NULL, 0);
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }
    while (do_wait(0, NULL) == 0) {
        schedule();
    }
    //......
    cprintf("init check memory pass.\n");
    return 0;
}
```

（2）`schedule`函数从进程链表中选中该`PROC_RUNNABLE`态的进程，调用`proc_run()`函数运行该进程。
```c
void schedule(void) {
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
        last = (current == idleproc) ? &proc_list : &(current->list_link);
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
                    break;
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
            next = idleproc;
        }
        next->runs ++;
        if (next != current) {
            proc_run(next);
        }
    }
    local_intr_restore(intr_flag);
}
```
（3）进入`user_main`线程后，通过宏`KERNEL_EXECVE`宏定义调用`__KERNEL_EXECVE`函数，从中调用`kernel_execve`函数。首先将系统调用号、函数名称、函数长度、代码地址、代码大小存储在寄存器中。由于目前我们在`S mode`下，所以不能通过`ecall`来产生中断，只能通过设置`a7`寄存器的值为`10`后用`ebreak`产生断点中断转发到`syscall()`来实现在内核态使用系统调用。之后将存储在`a0`寄存器中的系统调用号作为返回值返回。
```c
static int user_main(void *arg) {
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
}
```
```c

#define __KERNEL_EXECVE(name, binary, size) ({                          \
            cprintf("kernel_execve: pid = %d, name = \"%s\".\n",        \
                    current->pid, name);                                \
            kernel_execve(name, binary, (size_t)(size));                \
        })

#define KERNEL_EXECVE(x) ({                                             \
            extern unsigned char _binary_obj___user_##x##_out_start[],  \
                _binary_obj___user_##x##_out_size[];                    \
            __KERNEL_EXECVE(#x, _binary_obj___user_##x##_out_start,     \
                            _binary_obj___user_##x##_out_size);         \
        })

#define __KERNEL_EXECVE2(x, xstart, xsize) ({                           \
            extern unsigned char xstart[], xsize[];                     \
            __KERNEL_EXECVE(#x, xstart, (size_t)xsize);                 \
        })

#define KERNEL_EXECVE2(x, xstart, xsize)        __KERNEL_EXECVE2(x, xstart, xsize)
```

```c
static int kernel_execve(const char *name, unsigned char *binary, size_t size) {
    int64_t ret=0, len = strlen(name);
 //   ret = do_execve(name, len, binary, size);
    asm volatile(
        "li a0, %1\n"
        "lw a1, %2\n"
        "lw a2, %3\n"
        "lw a3, %4\n"
        "lw a4, %5\n"
    	"li a7, 10\n"
        "ebreak\n"
        "sw a0, %0\n"
        : "=m"(ret)
        : "i"(SYS_exec), "m"(name), "m"(len), "m"(binary), "m"(size)
        : "memory");
    cprintf("ret = %d\n", ret);
    return ret;
}
```


（4）当`ucore`收到此系统调用后，首先进入`kern\trap\trapentry.S`中的`_alltraps`保存当前的寄存器状态，然后跳转到`trap`函数中根据发生的陷阱类型进行分发。`trap_dispatch`根据`tf->cause`将处理任务分发给`exception_handler`，之后根据寄存器`a7`的值为`10`调用函数`syscall()`。
```c
__alltraps:
    SAVE_ALL
    move  a0, sp
    jal trap
    # sp should be the same as before "jal trap"
    .globl __trapret
__trapret:
    RESTORE_ALL
    # return from supervisor call
    sret
void trap(struct trapframe *tf) {
    if (current == NULL) {
        trap_dispatch(tf);
    } else {
        struct trapframe *otf = current->tf;
        current->tf = tf;
        bool in_kernel = trap_in_kernel(tf);
        trap_dispatch(tf);
        //......
    }
}
static inline void trap_dispatch(struct trapframe* tf) {
    if ((intptr_t)tf->cause < 0) {
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
    }
}
void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
        //......
        case CAUSE_BREAKPOINT:
            cprintf("Breakpoint\n");
            if(tf->gpr.a7 == 10){
                tf->epc += 4;
                syscall();
                kernel_execve_ret(tf,current->kstack+KSTACKSIZE);
            }
            break;
        //......
    }
}
```
（5）在内核态的函数`syscall()`中通过`trapframe`读取寄存器的值，将系统调用号以及其他参数传给函数指针的数组syscalls。
```c
void syscall(void) {
    struct trapframe *tf = current->tf;
    uint64_t arg[5];
    int num = tf->gpr.a0;//a0寄存器保存了系统调用编号
    if (num >= 0 && num < NUM_SYSCALLS) {
        if (syscalls[num] != NULL) {
            arg[0] = tf->gpr.a1;
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
            //把寄存器里的参数取出来，转发给系统调用编号对应的函数进行处理
            return ;
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
//系统调用函数指针数组
static int (*syscalls[])(uint64_t arg[]) = {
    [SYS_exit]              sys_exit,
    [SYS_fork]              sys_fork,
    [SYS_wait]              sys_wait,
    [SYS_exec]              sys_exec,
    [SYS_yield]             sys_yield,
    [SYS_kill]              sys_kill,
    [SYS_getpid]            sys_getpid,
    [SYS_putc]              sys_putc,
    [SYS_pgdir]             sys_pgdir,
};
```
（6）在调用过程中`syscalls=SYS_exec`，因此会调用函数`sys_exec`。函数`sys_exec`对于四个参数进行处理后调用函数`do_execve(name, len, binary, size)`。
```c
static int sys_exec(uint64_t arg[]) {
    const char *name = (const char *)arg[0];
    size_t len = (size_t)arg[1];
    unsigned char *binary = (unsigned char *)arg[2];
    size_t size = (size_t)arg[3];
    return do_execve(name, len, binary, size);
}
```
（7）`do_execve()`函数中首先替换掉当前线程中的`mm_struct`为加载新的执行码做好用户态内存空间清空准备，之后调用`load_icode()`函数把新的程序加载到当前进程，并设置好进程名字。
```c

int do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
    // 获取当前进程的内存管理结构体指针mm
    struct mm_struct *mm = current->mm;
    // 检查传入的可执行文件名（通过name指针指向）所在的内存区域是否可合法访问，
    // 调用user_mem_check函数进行检查，传入当前进程内存管理结构体、文件名内存地址、文件名长度以及其他相关参数（这里为0，具体含义需结合user_mem_check函数定义确定）
    // 如果内存检查不通过（函数返回false），说明文件名对应的内存区域不合法，函数直接返回表示参数无效的错误码 -E_INVAL
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
        return -E_INVAL;
    }
    // 如果传入的文件名长度大于规定的进程名称最大长度（PROC_NAME_LEN），则将长度截断为最大长度
    if (len > PROC_NAME_LEN) {
        len = PROC_NAME_LEN;
    }
    // 创建一个本地的字符数组local_name，用于存储可执行文件的名称
    char local_name[PROC_NAME_LEN + 1];
    //将local_name数组的内容初始化为0，确保字符串初始化正确
    memset(local_name, 0, sizeof(local_name));
    //将传入的可执行文件名（通过name指针指向，长度为len）复制到local_name数组中
    memcpy(local_name, name, len);
    // 如果当前进程的内存管理结构体指针mm不为空，说明当前进程已经有分配的内存空间，
    //需要进行清理回收操作
    if (mm!= NULL) {
        // 输出提示信息"mm!= NULL"，可能用于调试目的，查看执行流程中此条件是否满足
        cputs("mm!= NULL");
        // 将处理器的页目录基址寄存器（CR3）设置为启动时的页目录基址boot_cr3
        lcr3(boot_cr3);
        if (mm_count_dec(mm) == 0) {
            // 调用exit_mmap函数用于释放进程的内存映射相关资源
            exit_mmap(mm);
            // 调用put_pgdir函数用于释放页目录相关资源
            put_pgdir(mm);
            // 调用mm_destroy函数用于销毁内存管理结构体本身，释放其占用的内存等相关资源
            mm_destroy(mm);
        }
        current->mm = NULL;
    }
    // 用于存储后续函数调用的返回值
    int ret;
    if ((ret = load_icode(binary, size))!= 0) {
        goto execve_exit;
    }
    // 将当前进程的名称设置为新的可执行文件的名称
    set_proc_name(current, local_name);
    // 如果一切顺利，函数执行成功，返回0表示执行execve操作成功
    return 0;
execve_exit:
    do_exit(ret);
    panic("already exit: %e.\n", ret);
}
```
（8）回到`exception_handler()`函数中更新内核栈位置，然后回到`__trapret`函数中将寄存器设置为应用进程的相关状态，当`__trapret`执行sret指令时就会跳转到应用程序的入口中，并且特权级也由内核态跳转到用户态，接下来就开始执行用户程序的第一条指令。

**整理说明如下：**
从`proc_init`（创建了 `idle`第0个内核线程,然后调用 `kernel_thread `创建了 `init` 第1个内核线程）然后到 `cpu_idle` 会不断的去查询`need_resched`标志位，调用`schedule`函数进行调度，在`schedule`找到第一个可以调度的线程后调用`proc_run`函数来切换到新进程，proc_run`调用了`lcr3`和`switch_to。然后返回到 `kernel_thread_entry`去执行指定的函数，这里面就是去执行了`initproc`进程的主函数`init_main`。

上面这段与Lab4一致，Lab5接下来有所区别.在`init_main`中再次调用了`kernel_thread`去创建我们想去执行的程序`user_main`

该函数会在缺省的时候调用`KERNEL_EXECVE(exit)，KERNEL_EXECVE`这个宏,最后会去调用`kernel_execve()`函数，`kernel_execve()`函数会通过内联汇编调用，使用`ebx`指令来产生断点,并通过设置`a7`寄存器的值为10，让在`trap.c`文件中处理断点的时候去调用`syscall()`函数和`kernel_execve_ret()`函数。`kernel_execve_ret()`在 traperty.S中定义；另一方面在`kernel_execve()`的内联汇编中将`sys_exec`宏放入了`a0`寄存器，让其执行一个系统调用`sys_exec()`函数，`sys_exec()`函数会调用`do_execve()`函数，`do_execve()` 函数中调用`load_icode()`函数来加载新的二进制程序到内存中，这个函数也设置了中断帧的一些内容，SFP设置为0，让其可以后面直接返回到用户态。

创建完`user_main`的那个线程后不会立刻执行，而且执行`init_main`函数后面的逻辑，这里会调用`do_wait()`函数，让当前进程等待指定的子进程结束，并获取子进程的退出状态。对于当前进程来说，其实只有一个`usermain`是他子进程，并调用`schedule()` 函数进行调度，此时调度就会选中`user_main`进行执行。

首先会按照上文过程加载这个二进制程序，会把`exit`应用程序执行码覆盖到`usermain`的用户虚拟内存空间，然后去执行`kernel_execve_ret()`,最后通过`sret`退出到用户态，开始执行`initcode.S`中代码.
## 练习2：父进程复制自己的内存空间给子进程(需要编码)

> 创建子进程的函数`do_fork`在执行中将拷贝当前进程(即父进程)的用户内存地址空间中的合法内容到新进程中(子进程)，完成内存资源的复制。具体是通过`copy_range`函数(位于`kern/mm/pmm.c`中)实现的，请补充`copy_range`的实现，确保能够正确执行。
> 请在实验报告中简要说明你的设计实现过程。
> - 如何设计实现`Copy on Write`机制？给出概要设计，鼓励给出详细设计。


在`do_fork`函数中，通过调用`copy_mm`来执行内存空间的复制。在这一过程中，进一步调用了`dup_mmap`函数，该函数的核心操作是遍历父进程的所有合法虚拟内存空间，然后将这些空间的内容复制到子进程的内存空间中。具体而言，这一内存复制的实现是通过`copy_range`函数完成的。
```c
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS)
    {
        goto fork_out;
    }
    ret = -E_NO_MEM;
    if ((proc = alloc_proc()) == NULL)
    {
        goto fork_out;
    }
    proc->parent = current;
    assert(current->wait_state == 0); // 确保进程在等待
    if (setup_kstack(proc) != 0)
    {
        goto bad_fork_cleanup_proc;
    }
    if (copy_mm(clone_flags, proc) != 0)
    {
        goto bad_fork_cleanup_kstack;
    }
    copy_thread(proc, stack, tf);
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        proc->pid = get_pid();
        hash_proc(proc);
        set_links(proc); // 设置进程链接
    }
    local_intr_restore(intr_flag);
    wakeup_proc(proc);
    ret = proc->pid;
    //......
}
static int copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
    struct mm_struct *mm, *oldmm = current->mm;
    if (oldmm == NULL) {
        return 0;
    }
    if (clone_flags & CLONE_VM) {
        mm = oldmm;
        goto good_mm;
    }
    int ret = -E_NO_MEM;
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    if (setup_pgdir(mm) != 0) {
        goto bad_pgdir_cleanup_mm;
    }
    lock_mm(oldmm);
    {
        ret = dup_mmap(mm, oldmm);
    }
    unlock_mm(oldmm);

    if (ret != 0) {
        goto bad_dup_cleanup_mmap;
    }
    //......
}
int dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list) {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
        if (nvma == NULL) {
            return -E_NO_MEM;
        }
        insert_vma_struct(to, nvma);
        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
}
```
在`copy_range`中实现了将父进程的内存空间复制给子进程的功能。逐个内存页进行复制，首先找到父进程的页表项，然后创建一个子进程新的页表项，设置对应的权限，然后将父进程的页表项对应的内存页复制到子进程的页表项对应的内存页中，然后将子进程的页表项加入到子进程的页表中。

练习需要完成的部分是复制页面的内容到子进程需要被填充的物理页`npage`，建立`npage`的物理地址到线性地址`start`的映射。步骤如下：

1. 使用宏`page2kva(page)`  找到父进程需要复制的物理页的内核虚拟地址；
2. 使用宏`page2kva(npage)` 找到子进程需要被填充的物理页的内核虚拟地址；
3. 使用`memcpy(kva_dst, kva_src, PGSIZE)`将父进程的物理页的内容复制到子进程中去；
4. 通过`page_insert(to, npage, start, perm)`建立子进程的物理页与虚拟页的映射关系。

代码如下：

```c
void *kva_src = page2kva(page); 
void *kva_dst = page2kva(npage); 
memcpy(kva_dst, kva_src, PGSIZE); 
ret = page_insert(to, npage, start, perm);
```

完成所有编码后，`make grade`输出截图：
![alt text](19116307337023776.png)

## 练习3：阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现（不需要编码）

> 请在实验报告中简要说明你对 fork/exec/wait/exit函数的分析。并回答如下问题：
>
> - 请分析fork/exec/wait/exit的执行流程。重点关注哪些操作是在用户态完成，哪些是在内核态完成？内核态与用户态程序是如何交错执行的？内核态执行结果是如何返回给用户程序的？
> - 请给出ucore中一个用户态进程的执行状态生命周期图（包括执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用）。（字符方式画即可）

### （一）ucore的系统调用:

- SYS_exit：进程退出                          -->do_exit

- SYS_fork：创建子进程，复制内存映像            -->do_fork-->wakeup_proc

- SYS_wait ：等待进程                            -->do_wait

- SYS_exec ：在fork之后，进程执行程序  -->load a program and refresh the mm

- SYS_clone ：创建子线程                    -->do_fork-->wakeup_proc

- SYS_yield：放弃 CPU 时间片，进程标志需要重新调度- -->proc->need_sched=1, then scheduler will rescheule this process

- SYS_sleep：进程休眠                           -->do_sleep 

- SYS_kill ：终止进程                           -->do_kill-->proc->flags |=PF_EXITING -->wakeup_proc-->do_wait-->do_exit   

- SYS_getpid ：获取进程的PID

### （二）问题回答

1. 请分析fork/exec/wait/exit的执行流程。重点关注哪些操作是在用户态完成，哪些是在内核态完成？内核态与用户态程序是如何交错执行的？内核态执行结果是如何返回给用户程序的？

   在用户态下，进程只能执行一般的指令，无法执行特权指令。因此，系统调用机制为用户进程提供了一个统一的接口层，使其能够获得操作系统的服务。通过调用系统调用接口，用户进程可以方便地请求操作系统提供各种功能和服务，从而简化了用户进程的实现。这种机制使得用户进程可以在受限的特权级别下安全地执行，并且提供了一种可控的方式来访问操作系统的功能。

   用户态使用`syscall`的逻辑是：

   (1) 实现用户态程序进行系统调用的接口，这些接口最终会去调用用户态的`syscall`函数(`users/libs/syscall.c`)。此时为U mode。

   - `user/libs/ulib.c`：实现了最小的C函数库，除了一些与系统调用无关的函数，其他函数是对访问系统调用的包装。对访问系统调用的包装，提供了用户级应用程序常用的接口，如创建新进程(`fork`)、等待进程退出(`wait`、`waitpid`)、放弃 CPU 时间片(`yield`)、终止进程(`kill`、`exit`)、获取进程PID(`getpid`)等。



   - `user/libs/syscall.c`：用户层发出系统调用的具体实现。会去调用`syscall`函数.

   (2) `users` 里的`syscall`，通过内联汇编进行`ecall`调用。这将产生一个trap, 此时由U mode 进入S mode进行异常处理。

   ```c
   static inline int syscall(int num, ...) {
       //va_list, va_start, va_arg都是C语言处理参数个数不定的函数的宏
       //在stdarg.h里定义
       va_list ap; //ap: 参数列表(此时未初始化)
       va_start(ap, num); //初始化参数列表, 从num开始
       //First, va_start initializes the list of variable arguments as a va_list.
       uint64_t a[MAX_ARGS];
       int i, ret;
       for (i = 0; i < MAX_ARGS; i ++) { //把参数依次取出
           a[i] = va_arg(ap, uint64_t);
       }
       va_end(ap); 
       asm volatile (
           "ld a0, %1\n"
           "ld a1, %2\n"
           "ld a2, %3\n"
           "ld a3, %4\n"
           "ld a4, %5\n"
           "ld a5, %6\n"
           "ecall\n"
           "sd a0, %0"
           : "=m" (ret)
           : "m"(num), "m"(a[0]), "m"(a[1]), "m"(a[2]), "m"(a[3]), "m"(a[4])
           :"memory");
       //num存到a0寄存器， a[0]存到a1寄存器
       //ecall的返回值存到ret
       return ret;
   }
   ```

   (3)`trap.c`转发系统调用，触发内核态的系统调用(`kern/syscall/syscall.c`)。此时为S mode。

   ```c
   // kern/trap/trap.c
   void exception_handler(struct trapframe *tf) {
       int ret;
       switch (tf->cause) { //通过中断帧里 scause寄存器的数值，判断出当前是来自USER_ECALL的异常
           case CAUSE_USER_ECALL:
               //cprintf("Environment call from U-mode\n");
               tf->epc += 4; 
               //sepc寄存器是产生异常的指令的位置，在异常处理结束后，会回到sepc的位置继续执行
               //对于ecall, 我们希望sepc寄存器要指向产生异常的指令(ecall)的下一条指令
               //否则就会回到ecall执行再执行一次ecall, 无限循环
               syscall();// 进行系统调用处理
               break;
           /*other cases .... */
       }
   }
   ```

   (4) 在内核态的`syscall`函数中，根据参数调用编号调用相应函数。此时为S mode。

   ```c
   // kern/syscall/syscall.c
   void syscall(void) {
       struct trapframe *tf = current->tf;
       uint64_t arg[5];
       int num = tf->gpr.a0;  // a0寄存器保存了系统调用编号
       if (num >= 0 && num < NUM_SYSCALLS) { //  防止syscalls[num]下标越界
           if (syscalls[num] != NULL) {
               arg[0] = tf->gpr.a1;
               arg[1] = tf->gpr.a2;
               arg[2] = tf->gpr.a3;
               arg[3] = tf->gpr.a4;
               arg[4] = tf->gpr.a5;
               tf->gpr.a0 = syscalls[num](arg); 
               // 把寄存器里的参数取出来，转发给系统调用编号对应的函数进行处理
               return ;
           }
       }
       //如果执行到这里，说明传入的系统调用编号还没有被实现，就崩掉了。
       print_trapframe(tf);
       panic("undefined syscall %d, pid = %d, name = %s.\n",
               num, current->pid, current->name);
   }
   ```

   其中`tf->gpr.a0 = syscalls[num](arg); `指令，去根据参数调用相应的对应函数。

   ```c
   // kern/syscall/syscall.c
   // 这里定义了函数指针的数组syscalls, 把每个系统调用编号的下标上初始化为对应的函数指针
   static int (*syscalls[])(uint64_t arg[]) = {
       [SYS_exit]              sys_exit,
       [SYS_fork]              sys_fork,
       [SYS_wait]              sys_wait,
       [SYS_exec]              sys_exec,
       [SYS_yield]             sys_yield,
       [SYS_kill]              sys_kill,
       [SYS_getpid]            sys_getpid,
       [SYS_putc]              sys_putc,
   };
   
   // syscall的数量
   #define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))
   
   // libs/unistd.h
   // 这些编号
   /* syscall number */
   #define SYS_exit            1
   #define SYS_fork            2
   #define SYS_wait            3
   #define SYS_exec            4
   #define SYS_clone           5
   #define SYS_yield           10
   #define SYS_sleep           11
   #define SYS_kill            12
   #define SYS_gettime         17
   #define SYS_getpid          18
   #define SYS_brk             19
   #define SYS_mmap            20
   #define SYS_munmap          21
   #define SYS_shmem           22
   #define SYS_putc            30
   #define SYS_pgdir           31
   ```

   (5) 相应函数执行流程，均在S mode中进行

   - **fork**

     调用过程：SYS_fork->do_fork + wakeup_proc

     ```c
     static int sys_fork(uint64_t arg[]) {
         struct trapframe *tf = current->tf;
         uintptr_t stack = tf->gpr.sp;
         return do_fork(0, stack, tf); // clone_flags 为0，不可以共享地址空间
     }
     ```

     do_fork执行流程：

     1、分配并初始化进程控制块(alloc_proc 函数);
     2、分配并初始化内核栈(setup_stack 函数);
     3、根据 clone_flag标志复制或共享进程内存管理结构(copy_mm 函数);
     4、设置进程在内核(将来也包括用户态)正常运行和调度所需的中断帧和执行上下文(copy_thread 函数);
     5、把设置好的进程控制块放入hash_list 和 proc_list 两个全局进程链表中;
     6、自此,进程已经准备好执行了,把进程状态设置为“就绪”态;
     7、设置返回码为子进程的 id 号。

   - **exec**

     调用过程： SYS_exec->do_execve

     ```c
     static int sys_exec(uint64_t arg[]) {
         const char *name = (const char *)arg[0];
         size_t len = (size_t)arg[1];
         unsigned char *binary = (unsigned char *)arg[2];
         size_t size = (size_t)arg[3];
         return do_execve(name, len, binary, size);
     }
     ```

     do_execve执行流程：

     1、首先为加载新的执行码做好用户态内存空间清空准备。如果mm不为NULL，则设置页表为内核空间页表，且进一步判断mm的引用计数减1后是否为0，如果为0，则表明没有进程再需要此进程所占用的内存空间，为此将根据mm中的记录，释放进程所占用户空间内存和进程页表本身所占空间。最后把当前进程的mm内存管理指针为空。
     2、接下来是加载应用程序执行码到当前进程的新创建的用户态虚拟空间中。之后就是调用load_icode从而使之准备好执行。

   - **wait**

     调用过程： SYS_wait->do_wait

     ```c
     static int sys_wait(uint64_t arg[]) {
         int pid = (int)arg[0];
         int *store = (int *)arg[1];
         return do_wait(pid, store);
     }
     ```

     `sys_wait `的核心逻辑在 `do_wait` 函数中，根据传入的参数 `pid` 决定是回收指定 `pid` 的子线程还是任意一个子线程。

     do_wait执行流程：

     1、 如果 pid!=0，表示只找一个进程 id 号为 pid 的退出状态的子进程，否则找任意一个处于退出状态的子进程;
     2、 如果此子进程的执行状态不为PROC_ZOMBIE，表明此子进程还没有退出，则当前进程设置执行状态为PROC_SLEEPING（睡眠），睡眠原因为WT_CHILD(即等待子进程退出)，调用schedule()函数选择新的进程执行，自己睡眠等待，如果被唤醒，则重复跳回步骤 1 处执行;
     3、 如果此子进程的执行状态为 PROC_ZOMBIE，表明此子进程处于退出状态，需要当前进程(即子进程的父进程)完成对子进程的最终回收工作，即首先把子进程控制块从两个进程队列proc_list和hash_list中删除，并释放子进程的内核堆栈和进程控制块。自此，子进程才彻底地结束了它的执行过程，它所占用的所有资源均已释放。

   - **exit**

     调用过程：sys_exit->do_exit

     ```c
     static int sys_exit(uint64_t arg[]) {
         int error_code = (int)arg[0];
         return do_exit(error_code);
     }
     ```

     do_exit执行流程：

     1、先判断是否是用户进程，如果是，则开始回收此用户进程所占用的用户态虚拟内存空间;（具体的回收过程不作详细说明）
     2、设置当前进程状态为PROC_ZOMBIE，然后设置当前进程的退出码为error_code。表明此时这个进程已经无法再被调度了，只能等待父进程来完成最后的回收工作（主要是回收该子进程的内核栈、进程控制块）
     3、如果当前父进程已经处于等待子进程的状态，即父进程的wait_state被置为WT_CHILD，则此时就可以唤醒父进程，让父进程来帮子进程完成最后的资源回收工作。
     4、如果当前进程还有子进程,则需要把这些子进程的父进程指针设置为内核线程init,且各个子进程指针需要插入到init的子进程链表中。如果某个子进程的执行状态是 PROC_ZOMBIE,则需要唤醒 init来完成对此子进程的最后回收工作。
     5、执行schedule()调度函数，选择新的进程执行。

   (6) 系统调用完中断返回，进入用户态进程，由S mode转为U mode 

   在`_trapret`处使用RESTORE_ALL恢复所有寄存器，如果是用户态产生的中断，此时sp恢复为用户栈指针。然后调用sret指令从S mode返回U mode。其中，sret指令将状态的程序计数器(PC)和特权级别寄存器(如状态寄存器)中保存的U态的值加回到对应的寄存器中。同时，sret指令也会将S态的特权级别切换回到U态，这样处理器就会从S态切换回到U态，并开始执行U态的指令。

   在用户态的syscall中，将ecall的返回值存到`ret`，并将`ret` 变量被存储到 `a0` 寄存器中，因此内核态执行结果通过寄存器 `a0` 返回给用户程序。

2. 请给出ucore中一个用户态进程的执行状态生命周期图（包括执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用）。（字符方式画即可）

```
                       +-------------+
               +--> |	 none 	  |
               |    +-------------+       ---+
               |          | alloc_proc	     |
               |          V				     |
               |    +-------------+			 |
               |    | PROC_UNINIT |			 |---> do_fork
               |    +-------------+			 |
      do_wait  |         | wakeup_proc		 |
               |         V			   	  ---+
               |    +-------------+    do_wait 	  	  +-------------+
               |    |PROC_RUNNABLE| <------------>    |PROC_SLEEPING|
               |    +-------------+    wake_up        +-------------+
               |         | do_exit
               |         V
               |    +-------------+
               +--- | PROC_ZOMBIE |
                    +-------------+
```
## 扩展练习 Challenge1
实验要求
> 实现 Copy on Write （COW）机制
>
> 给出实现源码，测试用例和设计报告（包括在cow情况下的各种状态转换（类似有限状态自动机）的说明）。
>
> 这个扩展练习涉及到本实验和上一个实验“虚拟内存管理”。请在ucore中实现这样的COW机制。
>

COW基本机制为：在ucore操作系统中，当一个用户父进程创建自己的子进程时，父进程会把其申请的用户空间设置为只读，子进程可共享父进程占用的用户内存空间中的页面（这就是一个共享的资源）。当其中任何一个进程修改此用户内存空间中的某页面时，ucore会通过page fault异常获知该操作，并完成拷贝内存页面，使得两个进程都有各自的内存页面。这样一个进程所做的修改不会被另外一个进程可见了。

COW是存储系统中使用的基本更新策略之一。基本模式永远不会覆盖旧数据。使用COW策略更新数据块时，数据块被读入内存，进行修改，然后写入新位置，而旧数据则保持不变。由于COW永远不会覆盖旧数据，因此通常用于防止由于本地文件系统中的系统崩溃而导致数据丢失,COW更新策略已在存储系统中广泛使用

为了标记某一个虚拟页被用于COW了，使用了reserved的一个标志位

```c
//在mmu.h
// page table entry (PTE) fields
#define PTE_V     0x001 // Valid
#define PTE_R     0x002 // Read
#define PTE_W     0x004 // Write
#define PTE_X     0x008 // Execute
#define PTE_U     0x010 // User
#define PTE_G     0x020 // Global
#define PTE_A     0x040 // Accessed
#define PTE_D     0x080 // Dirty
#define PTE_COW   0x100 //用于COW
#define PTE_SOFT  0x200 // Reserved for Software

```

在`do_fork`函数中，内存复制通过`copy_mm`函数，然后再调用`dup_mmap`函数,最后调用`copy_range`函数。`copy_range`函数根据传入的参数`share`决定是否进行内存复制或共享。

```c
//`do_fork`函数
if (copy_mm(clone_flags, proc) != 0)
    {
        goto bad_fork_cleanup_kstack;
    }

//copy_mm函数

{
    ret = dup_mmap(mm, oldmm);
}

//dup_mmap

if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }

```

如果参数`share`为0，则与练习1代码一致完整拷贝内存；如果`share`为1，则令其使用COW机制，进行物理页面共享，在新的进程页目录表中加入共享页面的映射关系，并设置只读。

```c

//kern/mm/pmm.c中copy_range函数
 if (share)
{
    cprintf("Copy on Write. Sharing the page 0x%x\n,物理页0x%x\n", page2kva(page),page2pa(page));
    // 物理页面共享，建立映射关系并设置两个PTE上的标志位为只读，且标志为COW用途
    page_insert(from, page, start, (perm | PTE_COW) & ~PTE_W );
    ret = page_insert(to, page, start, (perm | PTE_COW) & ~PTE_W );//设置是COW
}
// 完整拷贝内存
else
{
    //练习2的内容，省略了
}

```

当其中任何一个进程修改此用户内存空间中的某页面时，由于PTE上的`PTE_W`为0，所以会触发缺页异常。此时需要通过`page fault`异常获知该操作,就需要调用`do_pgfault`函数，并完成拷贝内存页面，使得两个进程都有各自的内存页面。

在`do_pgfault`函数内，会尝试获取这个地址对应的页表项，如果页表项不为空，且页表项有效，这说明缺页异常是因为试图在只读页面中写入而引起的。

在这种情况下会判断是不是COW页，如果试图写入的只读页面只被一个进程使用，重设权限`PTE_W`为1并插入映射即可；

而如果被多个进程使用且是COW页，调用`pgdir_alloc_page`函数，在该函数内分配物理页面页面并设置新地址映射。之后，将数据拷贝到新分配的页中，并将其加入全局虚拟内存交换管理器的管理。

```c
 // 如果有效且不为空则是试图写入只读页面
struct Page *page = NULL;
        // 如果有效且不为空则是试图写入只读页面
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
    // Lab 3 中的代码
    // 页面被交换到了磁盘中
    // 将线性地址对应的物理页数据从磁盘交换到物理内存
}
swap_map_swappable(mm, addr, page, 1);
page->pra_vaddr = addr;
```

然后make qemu

![alt text](image-3.png)
可以看到这里使用了do_pgfault且输出了相关信息，初步证明是可以使用的。
## 扩展练习 Challenge2

> 说明该用户程序是何时被预先加载到内存中的？与我们常用操作系统的加载有何区别，原因是什么？

该用户程序在操作系统加载时一起加载到内存里。我们平时使用的程序在操作系统启动时还位于磁盘中，只有当我们需要运行该程序时才会被加载到内存里。

原因是在Makefile里执行了ld命令，把执行程序的代码连接在了内核代码的末尾。

### （一）实验中用户程序的加载方式

在Lab5的Makefile中会将用户程序编译到镜像中。Makefile中的user programs模块中的语句解析如下：

```assembly
# -------------------------------------------------------------------
# user programs
# 用户程序相关的头文件搜索路径
UINCLUDE	+= user/include/ \
			   user/libs/
# 用户程序源文件目录
USRCDIR		+= user
# 用户程序库目录
ULIBDIR		+= user/libs
# 用户程序编译选项
UCFLAGS		+= $(addprefix -I,$(UINCLUDE))
# 用户程序目标文件列表
USER_BINS	:=
# 添加用户库文件到编译目标中
$(call add_files_cc,$(call listf_cc,$(ULIBDIR)),ulibs,$(UCFLAGS))
# 添加用户源代码文件到编译目标中
$(call add_files_cc,$(call listf_cc,$(USRCDIR)),uprog,$(UCFLAGS))
# 生成用户程序目标文件列表
UOBJS	:= $(call read_packet,ulibs libs)
# 定义生成用户程序目标的规则
define uprog_ld
# 调用 ubinfile 宏生成的用户程序目标文件名
__user_bin__ := $$(call ubinfile,$(1))
# 存储了所有用户程序的目标文件名
USER_BINS += $$(__user_bin__)
$$(__user_bin__): tools/user.ld #依赖于链接脚本 tools/user.ld
$$(__user_bin__): $$(UOBJS)# 依赖于用户程序相关的目标文件列表 UOBJS
$$(__user_bin__): $(1) | $$$$(dir $$$$@)# 依赖于用户程序的源代码文件 ($(1))，并指定生成目标文件的路径。
	$(V)$(LD) $(LDFLAGS) -T tools/user.ld -o $$@ $$(UOBJS) $(1)# 使用 LD 进行链接，指定链接脚本为 tools/user.ld
	@$(OBJDUMP) -S $$@ > $$(call cgtype,$$<,o,asm)# 生成目标文件的反汇编文件 (.asm)
	@$(OBJDUMP) -t $$@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$$$/d' > $$(call cgtype,$$<,o,sym)# 生成目标文件的符号表文件 (.sym)
endef
# 遍历所有用户程序，生成目标
$(foreach p,$(call read_packet,uprog),$(eval $(call uprog_ld,$(p))))

```

在编译后会自动生成类似`_binary_obj___user_##x##_out_start`和`_binary_obj___user_##x##_out_size`这样的符号，按照C语言宏的语法，会直接把x的变量名代替\##x##。

`uprog_ld` 函数为每个用户程序生成目标文件后，通过链接脚本 `tools/user.ld` 来指导用户程序的链接过程。链接脚本 `tools/user.ld` 的具体解释如下：

```C
/* Simple linker script for ucore user-level programs.
   See the GNU ld 'info' manual ("info ld") to learn the syntax. */

OUTPUT_ARCH(riscv)  // 指定生成的可执行文件的体系结构为 RISC-V
ENTRY(_start)       // 指定程序的入口地址为 _start，这是用户程序的起始执行点

SECTIONS {           // 定义不同段的布局
    /* Load programs at this address: "." means the current address */
    . = 0x800020;    // 将程序加载到内存的地址 0x800020 处，这是用户程序的默认加载地址

    .text : {        // 包含代码段，用于存放程序的执行代码
        *(.text .stub .text.* .gnu.linkonce.t.*)
    }

    PROVIDE(etext = .);  // 定义符号 etext 的值为当前位置，即代码段的结束位置

    .rodata : {     // 包含只读数据段，用于存放只读的数据
        *(.rodata .rodata.* .gnu.linkonce.r.*)
    }

    /* Adjust the address for the data segment to the next page */
    . = ALIGN(0x1000);  // 调整地址，确保数据段从下一页开始

    .data : {       // 包含数据段，用于存放可读写的数据
        *(.data)
    }

    PROVIDE(edata = .);  // 定义符号 edata 的值为当前位置，即数据段的结束位置

    .bss : {        // 包含未初始化的数据段，用于存放未初始化的全局变量
        *(.bss)
    }

    PROVIDE(end = .);    // 定义符号 end 的值为当前位置，即 BSS 段的结束位置

    /DISCARD/ : {   // 丢弃一些不需要的段，包括 .eh_frame、.note.GNU-stack 和 .comment
        *(.eh_frame .note.GNU-stack .comment)
    }
}

```

通过连接器的加载，`$$(UOBJS)` 包含了用户程序的目标文件和用户库的目标文件，这些文件会被链接成最终的用户程序可执行文件 。之后根据连接器所决定的程序在内存中的布局，用户程序被加载到默认加载地址 `0x800020`，即各个段（如代码段、数据段、BSS 段等）从可执行文件复制到内存中的相应位置。

通过MakeFile的链接装入，用户程序就能够和ucore内核一起被 bootloader 加载到内存里中。

接下来在user_main()中，KERNEL_EXECVE宏会引入两个外部符号`_binary_obj___user_##x##_out_start`和`_binary_obj___user_##x##_out_size`，分别是ELF文件的开始地址和文件大小，之后作为`xstart`和`xsize`参数传递给`__KERNEL_EXECVE`用于调用`execve()`函数继续执行接下来的步骤。

### （二）操作系统的加载方式

在操作系统中装入内存有多种方式：

1. 绝对装入方式：预先知道装入的位置，编译过程中就将逻辑地址转为物理地址。
2. 可重定位装入方式：在装入的过程中，根据装入位置将装入模块中的逻辑地址修改为物理地址。
3. 动态运行装入方式：模块被装入内存后执行时通过基址寄存器来进行地址转换。

实际上机器的内存是有限的，如果同时运行多个进程，同时加载到内存时几乎不可能。因此操作系统会使用交换技术，把空闲的进程从内存中交换到磁盘上去，空余出的内存空间用于新进程的运行。如果换出去的空闲进程又需要被运行的时候，那么它就会被再次交换进内存中。

### （三）产生区别的原因

在Lab3页面置换的实验中我们分析可知QEMU里并没有真正模拟“硬盘”，我们实验中所用到的硬盘实际上是从内核的静态存储(static)区里面分出一块内存， 声称这块存储区域是”硬盘“，然后包裹一下给出”硬盘IO“的接口。 

我们目前还未实现文件系统，不能采用常用的利用文件系统的加载方式，因此只能采取makefile链接装入的形式。