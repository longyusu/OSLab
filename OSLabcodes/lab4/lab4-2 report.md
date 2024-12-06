# Lab4实验报告---练习二 #
练习内容：
创建一个内核线程需要分配和设置好很多资源。kernel\_thread函数通过调用do\_fork函数完成具体内核线程的创建工作。do\_kernel函数会调用alloc\_proc函数来分配并初始化一个进程控制块，但alloc\_proc只是找到了一小块内存用以记录进程的必要信息，并没有实际分配这些资源。ucore一般通过do\_fork实际创建新的内核线程。do\_fork的作用是，创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同。因此，我们实际需要"fork"的东西就是stack和trapframe。在这个过程中，需要给新内核线程分配资源，并且复制原进程的状态。你需要完成在kern/process/proc.c中的do\_fork函数中的处理过程。它的大致执行步骤包括：

调用alloc_proc，首先获得一块用户信息块。
为进程分配一个内核栈。
复制原进程的内存管理信息到新进程（但内核线程不必做此事）
复制原进程上下文到新进程
将新进程添加到进程列表
唤醒新进程
返回新进程号
请在实验报告中简要说明你的设计实现过程。请回答如下问题：

请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。


代码内容：
<pre><code>
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
    }
    ret = -E_NO_MEM;
    proc = alloc_proc();
    proc->parent = current;
    setup_kstack(proc);
    copy_mm(clone_flags, proc);
    copy_thread(proc, stack, tf);
    int pid = get_pid();
    proc->pid = pid;
    hash_proc(proc);
    list_add(&proc_list, &(proc->list_link));
    nr_process++;
    proc->state = PROC_RUNNABLE;
    ret = proc->pid; 
    
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}

</code></pre>

在上面的代码中，我们的设计思路大体如下：
首先调用函数alloc\_proc得到一个初始化的进程。接下来，将调用函数得到的进程proc的父进程设置为current即当前进程，调用函数setup\kstack、copy_mm为这个进程初始化一个栈和内存空间（虽然copy\_mm什么都没做）接下来，调用函数get\_pid得到一个返回值pid作为当前新创建进程的pid，使用函数hash\_proc与list\_add将新创建的进程填入进程表与哈希进程表，将nr\_process自增，代表当前系统内的进程又多了一个。最后将新创建的进程设置为可运行状态，将pid作为返回值。至此，我们大体实现了do\_fork函数的功能。

对于问题：请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。

我认为内核是可以做到的，首先我们直到当前进程的pid是由函数get\_pid返回得到的，所以我们要探究这个问题，需要对函数get\_pid进行一个详尽的分析：

<pre><code>
static intget_pid(void) {
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
        last_pid = 1;
        goto inside;
    }
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
            proc = le2proc(le, list_link);
            if (proc->pid == last_pid) {
                if (++ last_pid >= next_safe) {
                    if (last_pid >= MAX_PID) {
                        last_pid = 1;
                    }
                    next_safe = MAX_PID;
                    goto repeat;
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
}

</code></pre>

首先这个函数在开头处有一个断言，要求系统中的最大pid必须大于最大进程数量，接下来，我们初始化了如下几个变量，其含义大体如下：
proc、list、le:初始化了三个变量用于后面进行进程列表遍历。
next\_safe:代表当前还未分配的最小pid。
last\_pid:代表上次调用get\_pid函数时分发的pid。
首先每次调用该函数，如果last\_pid自增后仍小于next\_safe此时就返回last\_pid作为新的pid。如果大于，则我们就遍历整个进程表，在遍历过程中如果存在冲突我们就将next\_safe设置为MAX\_PID，否则如果，当前pid大于last\_pid但是小于next\_safe那么我们就将next\_safe设置为当前进程的pid。其中，我们需要主义的是，如果last\_pid大于MAX\_PID那么我们就将last\_pid的值置为1，从新开始循环使用pid。
