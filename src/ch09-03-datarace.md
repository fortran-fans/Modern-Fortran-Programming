# 数据竞争

如果我们通过多个image同时对某一个image进行修改，此时会发生数据竞争。例如其他的image同时对image1进行累加操作，当同时有多个image想要执行该操作时，就会出现错误。

``` fortran
program main
   implicit none
   integer::id,np,i
   integer::a[*]
   id = this_image()
   np = num_images()
   a=0
   do i = 1, np
      a[i]=a[i]+1
   end do
   sync all 
   write(*,*)"this image=",id,"a",a
end program main
```
多次运行就会发现结果并不正确，也不相同
``` sh
$ fpm run --compiler="caf" --runner="cafrun -n 4"
 this image=           2 a           4
 this image=           3 a           4
 this image=           4 a           3
 this image=           1 a           2
$ fpm run --compiler="caf" --runner="cafrun -n 4"
 this image=           4 a           3
 this image=           1 a           2
 this image=           2 a           4
 this image=           3 a           3
```
所以此处我们需要的`a[i]=a[i]+1`这条语句同时只能被一个image执行。

## `critical`
通过`critical`块语句，可以直接保证在该区域只有一个image执行

``` fortran
program main
   implicit none
   integer::id,np,i
   integer::a[*]
   id = this_image()
   np = num_images()
   a=0
   do i = 1, np
      critical
         a[i]=a[i]+1
      end critical
   end do
   sync all 
   write(*,*)"this image=",id,"a",a
end program main
```
``` sh
$ fpm run --compiler="caf" --runner="cafrun -n 4"
 this image=           3 a           4
 this image=           4 a           4
 this image=           1 a           4
 this image=           2 a           4
```
## 原子操作
Fortran内置函数中还提供了原子操作的函数，通过这些函数，可以实现上述功能
``` fortran
program main
   implicit none
   integer::id,np,i
   integer::a[*]
   id = this_image()
   np = num_images()
   a=0
   do i = 1, np
      call atomic_add(a[i],1)
   end do
   sync all 
   write(*,*)"this image=",id,"a",a
end program main
```
## 锁
使用`lock`语句也可以实现该功能
``` fortran
program main
   use iso_fortran_env
   implicit none
   integer::id,np,i
   integer::a[*]
   type(lock_type)::lock_a[*]
   id = this_image()
   np = num_images()
   a=0
   do i = 1, np
      lock(lock_a[i])
      a[i]=a[i]+1
      unlock(lock_a[i])
   end do
   sync all 
   write(*,*)"this image=",id,"a",a
end program main
```
- 使用`lock`的时候要注意`unlock`



