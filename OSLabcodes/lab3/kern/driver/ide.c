#include <assert.h>
#include <defs.h>
#include <fs.h>
#include <ide.h>
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}

#define MAX_IDE 2
//设置最多得IDE设备数量
#define MAX_DISK_NSECS 56
//扇区个数
static char ide[MAX_DISK_NSECS * SECTSIZE];
//模拟磁盘
bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
//这个函数检查给定的IDE设备编号 ideno 是否有效。如果 ideno 小于 MAX_IDE，则表示设备有效。
size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
//返回设备的大小
int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
    return 0;
}
//模拟从磁盘中读入数据到目标地址中dst
int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
    return 0;
}
//模拟将目标地址的数据写入磁盘中