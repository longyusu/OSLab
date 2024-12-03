## 练习1：为新创建的内核线程分配资源（需要编码）

> - `alloc\_proc`函数（位于`kern/process/proc.c`中）负责分配并返回一个新的`struct proc\_struct`结构，用于存储新建立的内核线程的管理信息。`ucore`需要对这个结构进行最基本的初始化，你需要完成这个初始化过程。
>   > 【提示】在`alloc\_proc`函数的实现中，需要初始化的`proc\_struct`结构中的成员变量至少包括：`state/pid/runs/kstack/need\_resched/parent/mm/context/tf/cr3/flags/name`。
>   请在实验报告中简要说明你的设计实现过程。请回答如下问题：
>    - 请说明`proc_struct`中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？（提示通过看代码和编程调试可以判断出来）

### 代码修改
```C
// kern/process/proc.h
struct proc_struct {
    enum proc_state state;            // 进程状态
    int pid;                          // 进程ID
    int runs;                         // 进程运行次数
    uintptr_t kstack;                 // 进程内核栈
    volatile bool need_resched;       // 布尔值：是否需要重新调度以释放CPU？
    struct proc_struct *parent;       // 父进程
    struct mm_struct *mm;             // 进程的内存管理字段
    struct context context;           // 切换至此以运行进程
    struct trapframe *tf;             // 当前中断的陷阱帧
    uintptr_t cr3;                    // CR3寄存器：页目录表(PDT)的基地址
    uint32_t flags;                   // 进程标志
    char name[PROC_NAME_LEN + 1];     // 进程名称
    list_entry_t list_link;           // 进程链接列表
    list_entry_t hash_link;           // 进程哈希列表
};
```
对每一个成员变量进行初始化，对于大部分的成员变量都需要执行清零操作，在此针对一些特殊的成员变量进行分析。
**（1）state**
state是进程所处的状态，`ucore`中进程状态有四种：分别是`PROC_UNINIT`（未初始化），`PROC_SLEEPING`（休眠），`PROC_RUNNABLE`（运行就绪），`PROC_ZOMBIE`（僵尸进程，等待父进程回收资源），因此当我们新开辟一个`struct proc_struct`结构后，还没有对应的进程信息，状态应当设置为`PROC_UNINIT`。
**（2）pid**
在刚分配`proc_struct`结构后，我们没有立即分配进程ID，因此进程ID应当是未初始化的值。需要注意进程中的ID号是从0开始的，0号进程即idle进程，因此未初始化的进程可以赋值为-1。
**（3）cr3**
 cr3 保存页表的物理地址，目的就是进程切换的时候方便直接使用cr3实现页表切换，避免每次都根据 mm 来计算 cr3。mm数据结构是用来实现用户空间的虚存管理的，但是内核线程没有用户空间，它执行的只是内核中的一小段代码，所以它没有mm 结构，也就是NULL。当某个进程是一个普通用户态进程的时候，PCB中的 cr3 就是 mm 中页表（pgdir）的物理地址；而当它是内核线程的时候，cr3 等于boot_cr3。而boot_cr3指向了uCore启动时建立好的内核虚拟空间的页目录表首地址。在本次实验中，我们新建的均为内核进程，因此`proc->cr3` 被设置为 `boot_cr3`。
**（4）其他**
`runs`：当进程初始化时，进程的运行次数为0，设置`runs=0`；`kstack`：当进程初始化时，进程内核栈暂未分配，因此内核栈位置设为0;`need_resched`：当进程初始化时，默认不需要立即重新调度;`parent`：当进程初始化时，父进程暂无，设置为NULL;`mm`：内核线程不需要考虑换页的问题，因此把之设置为NULL;`context`：使用`memset`函数开辟一块全零的`struct context`空间大小赋值;`tf` ：当进程初始化时，中断帧暂无，设置为NULL;`flags`：进程初始化时，进程标志默认为0; `name`：进程初始化时，名字使用0填充，长度为`PROC_NAME_LEN`
修改的代码如下：
```C++
// alloc_proc - 分配一个 proc_struct 结构体并初始化 proc_struct 的所有字段
static struct proc_struct *
alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));  // 分配一个 proc_struct 结构体
    if (proc != NULL) {  // 如果成功分配了内存
        proc->state = PROC_UNINIT;  // 将进程状态设置为未初始化
        proc->pid = -1;  // 将进程 ID 设置为 -1，表示未分配具体的进程 ID
        proc->runs = 0;  // 进程运行次数初始化为 0
        proc->kstack = 0;  // 进程内核栈地址设置为 0，表示未分配内核栈
        proc->need_resched = 0;  // 设置进程不需要重新调度
        proc->parent = NULL;  // 将父进程指针设为 NULL
        proc->mm = NULL;  // 将内存管理指针设为 NULL
        memset(&(proc->context), 0, sizeof(struct context));  // 使用 0 填充 proc 的 context 字段
        proc->tf = NULL;  // 将进程的 trapframe 指针设为 NULL
        proc->cr3 = boot_cr3;  // 将进程的 CR3 寄存器值设置为 boot_cr3
        proc->flags = 0;  // 进程标志位初始化为 0
        memset(proc->name, 0, PROC_NAME_LEN);  // 使用 0 填充进程的名称
    }
    return proc;  // 返回分配的 proc_struct 结构体指针
}
```
#### 验证：
![图 0](images/e0b798416d3c76616cecb4e230d77cc90410eb12c909168d4c2c249ef6597b77.png)  

### 问题回答

> 请说明`proc_struct`中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？（提示通过看代码和编程调试可以判断出来）

#### 1.`struct context context`

context结构体的定义如下：

```C
struct context {
    uintptr_t ra;// 返回地址
    uintptr_t sp;// 栈指针
    uintptr_t s0;// 保存的函数指针
    uintptr_t s1;// 保存函数参数
    uintptr_t s2;
    uintptr_t s3;
    uintptr_t s4;
    uintptr_t s5;
    uintptr_t s6;
    uintptr_t s7;
    uintptr_t s8;
    uintptr_t s9;
    uintptr_t s10;
    uintptr_t s11;
};
```

context结构体包含了`ra`，`sp`，`s0~s11`共14个被调用者保存寄存器。他的含义是进程上下文，作用是在内核态中能够进行上下文之间的切换。context结构体主要用于：


1.`copy_thread()`用于设置进程的中断帧和上下文，定义如下：

```C++
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
    // 设置子进程的上下文（context）中返回地址（ra）为 forkret 函数地址
    proc->context.ra = (uintptr_t)forkret;
    // 设置子进程的上下文（context）中栈指针（sp）为新进程的陷阱帧地址
    proc->context.sp = (uintptr_t)(proc->tf);
}
```

`ra`寄存器保存返回地址，在这里设置为`forkret` 函数地址，使进程经过switch_to进程切换后会返回到`forkret`函数；`sp`寄存器保存栈指针，这里设置为进程的中断帧，`__trapret`就可以直接从中断帧里面保存的trapframe信息恢复所有的寄存器，然后开始执行代码。因此，在copy_thread函数中，context的作用是通过寄存器设置进程的上下文状态从而帮助CPU进程切换。

2.`switch_to`函数的主要功能就是保留当前线程的上下文，并且将即将运行进程中上下文结构中的内容加载到CPU 的各个寄存器中，恢复新线程的执行流上下文现场。

`switch_to`函数的定义在`kern\process\switch.S`中，代码如下：

```assembly
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
    STORE sp, 1*REGBYTES(a0)
    STORE s0, 2*REGBYTES(a0)
    STORE s1, 3*REGBYTES(a0)
    STORE s2, 4*REGBYTES(a0)
    STORE s3, 5*REGBYTES(a0)
    STORE s4, 6*REGBYTES(a0)
    STORE s5, 7*REGBYTES(a0)
    STORE s6, 8*REGBYTES(a0)
    STORE s7, 9*REGBYTES(a0)
    STORE s8, 10*REGBYTES(a0)
    STORE s9, 11*REGBYTES(a0)
    STORE s10, 12*REGBYTES(a0)
    STORE s11, 13*REGBYTES(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
    LOAD sp, 1*REGBYTES(a1)
    LOAD s0, 2*REGBYTES(a1)
    LOAD s1, 3*REGBYTES(a1)
    LOAD s2, 4*REGBYTES(a1)
    LOAD s3, 5*REGBYTES(a1)
    LOAD s4, 6*REGBYTES(a1)
    LOAD s5, 7*REGBYTES(a1)
    LOAD s6, 8*REGBYTES(a1)
    LOAD s7, 9*REGBYTES(a1)
    LOAD s8, 10*REGBYTES(a1)
    LOAD s9, 11*REGBYTES(a1)
    LOAD s10, 12*REGBYTES(a1)
    LOAD s11, 13*REGBYTES(a1)

    ret
```

`a0`指向原进程，`a1`指向目的进程。在这段代码中，首先使用STORE指令将当前线程中context结构体中的所有寄存器都保存到内存中的地址`0*REGBYTES(a0)`中，接下来使用LOAD指令将即将加载的线程中的context结构体中的所有寄存器从内存地址 `0*REGBYTES(a1)` 加载值到返回地址寄存器中。

#### 2.`struct trapframe *tf`

`*tf`是中断帧的指针，总是指向内核栈的某个位置。当进程从用户空间跳到内核空间时，中断帧记录了进程在被中断前的状态。当内核需要跳回用户空间时，需要调整中断帧以恢复让进程继续执行的各寄存器值。

`trapframe`结构体的定义如下：

```C
struct trapframe {
    struct pushregs gpr;//包含众多寄存器
    uintptr_t status;//处理器的状态
    uintptr_t epc;//触发中断的指令的地址
    uintptr_t badvaddr;//最近一次导致发生地址错误的虚地址
    uintptr_t cause;//异常或中断的原因
};
```

1.在本次实验中，我们主要用到了`sstatus`寄存器的`SPP`、`SIE`、`SPIE`位，具体解释如下：	

- **SPP位:**`SPP` 记录进入 S-Mode 之前处理器的特权级别。值为 0 表示陷阱源自用户模式（U-Mode），值为 1 表示其他模式。在执行陷阱时，硬件会自动根据当前处理器状态自动设置 `SPP` 为 0 或 1。在执行 `SRET` 指令从陷阱中返回时，若 `SPP` 为 0，则处理器返回至 U-Mode；若 `SPP` 为 1，则返回至 S-Mode。最终，不论如何，`SPP` 都会被设置为 0。
- **SIE 位:**`SIE` 位是 S-Mode 下中断的总开关。若 `SIE` 为 0，则在 S-Mode 下发生的任何中断都不会得到响应。但是，如果当前处理器运行在 U-Mode 下，那么不论 `SIE` 为 0 还是 1，在 S-Mode 下的中断都默认是打开的。换言之，在任何时候，S-Mode 都有权因为自身的中断而抢占运行在 U-Mode 下的处理器。
- **SPIE位:**`SPIE` 位记录进入 S-Mode 之前 S-Mode 中断是否开启。在进入陷阱时，硬件会自动将 `SIE` 位的值保存到 `SPIE` 位上，相当于记录原先 `SIE` 的值，并将 `SIE` 置为 0。这表示硬件不希望在处理一个陷阱的同时被其他中断打扰，从硬件实现逻辑上来说，不支持嵌套中断。当使用 `SRET` 指令从 S-Mode 返回时，`SPIE` 的值会重新放置到 `SIE` 位上来恢复原先的值，并将 `SPIE` 的值置为 1。

2. `pushregs` 的结构体，包含了一系列寄存器如下：		

```C
struct pushregs {
    uintptr_t zero;  // 硬连线的零寄存器
    uintptr_t ra;    // 返回地址寄存器
    uintptr_t sp;    // 栈指针寄存器
    uintptr_t gp;    // 全局指针寄存器
    uintptr_t tp;    // 线程指针寄存器
    uintptr_t t0;    // 临时寄存器
    uintptr_t t1;    // 临时寄存器
    uintptr_t t2;    // 临时寄存器
    uintptr_t s0;    // 保存的寄存器/帧指针
    uintptr_t s1;    // 保存的寄存器
    uintptr_t a0;    // 函数参数/返回值
    uintptr_t a1;    // 函数参数/返回值
    uintptr_t a2;    // 函数参数
    uintptr_t a3;    // 函数参数
    uintptr_t a4;    // 函数参数
    uintptr_t a5;    // 函数参数
    uintptr_t a6;    // 函数参数
    uintptr_t a7;    // 函数参数
    uintptr_t s2;    // 保存的寄存器
    uintptr_t s3;    // 保存的寄存器
    uintptr_t s4;    // 保存的寄存器
    uintptr_t s5;    // 保存的寄存器
    uintptr_t s6;    // 保存的寄存器
    uintptr_t s7;    // 保存的寄存器
    uintptr_t s8;    // 保存的寄存器
    uintptr_t s9;    // 保存的寄存器
    uintptr_t s10;   // 保存的寄存器
    uintptr_t s11;   // 保存的寄存器
    uintptr_t t3;    // 临时寄存器
    uintptr_t t4;    // 临时寄存器
    uintptr_t t5;    // 临时寄存器
    uintptr_t t6;    // 临时寄存器
};
```

本次实验中一共有以下三处关键调用`trapframe`：

**（1）kernel_thread：**

```C
int kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
    // 对trameframe，也就是我们程序的一些上下文进行一些初始化
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
    // 设置内核线程的参数和函数指针
    tf.gpr.s0 = (uintptr_t)fn; // s0 寄存器保存函数指针，就是init_main函数
    tf.gpr.s1 = (uintptr_t)arg; // s1 寄存器保存函数参数
    // 设置 trapframe 中的 status 寄存器(SSTATUS)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
    // 将入口点(epc)设置为 kernel_thread_entry 函数
    tf.epc = (uintptr_t)kernel_thread_entry;
    // 使用 do_fork 创建一个新进程(内核线程)，这样才真正用设置的tf创建新进程。
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
}
```

在新创建一个进程后，首先将`s0`设置为函数指针，并使用`s1` 寄存器保存函数参数。由于我们在内核中新建线程，所以将状态寄存器的`SPP`位写设置为1，由于之前中断开启，之前的`SIE`位为1，所以我们使用`SPIE`置一记录状态，之后我们将`SIE`置零，禁用中断。最后将

**（2）`copy_thread`**

```C
proc->tf->gpr.a0 = 0;// 将 a0 设置为 0区分子进程
// 设置子进程的栈指针（sp），若 esp 为 0 则指向新进程的陷阱帧，否则指向传入的 esp
proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
```

**（3）`forkret`**

在copy_thread函数中设置每一个新线程的内核入口点为`forkret`的地址，并且在switch_to之后，当前进程将在这里执行。

```C
static void
forkret(void) {
    forkrets(current->tf);
}
```

在0号进程和1号进程切换时，栈指针指向的1号进程的中断帧，`ip`指向的是`forkret`，该函数做的就是把栈指针指向新进程的中断帧。`forkret` 相当于是起到一个中介的作用，`eip`是指令指针寄存器，当切换进程的时候，第一个要执行的指令就是`eip`指向的指令，而该指令恰好指向的就是`forkrets(current->tf)`，然后把当前进程的中断帧给设置为新进程的`esp`，也就是栈指针。

设置完当前进程的栈指针之后，跳转到`__trapret`，就开始把中断帧中保存的寄存器值都给加载到当前各寄存器上，相当于布置好了当前进程运行所需要的环境。


