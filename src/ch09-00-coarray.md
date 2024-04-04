# Coarray

Coarray是Fortran原生支持的用于并行计算的结构，通过使用Coarray可以比较简单的写出并行计算的程序。

## images

在Coarray中，每一个并行的最小单元称为image，Fortran中有两个内置函数`this_image()`和`num_images()`来获取当前的image和总的`image`的数量(**image的编号是从1开始的**)。

``` fortran
program main
  implicit none
  write(*,*)"this image=",this_image(),"num images",num_images()
end program main
```
需要使用这样的方式设置fpm
``` sh
$ fpm run --compiler="caf" --runner="cafrun -n 4"
 this image=           1 num images           4
 this image=           3 num images           4
 this image=           2 num images           4
 this image=           4 num images           4
```
其中image的输出顺序并不确定，因为哪一个images先运行到`write`位置本身是不确定的。

## `codimension`
如果需要在不同image之间进行交互，那就要引入`codimension`属性,用中括号表示。通过将一个变量引入该属性，他就获得了在不同的`image`之间交换数据的能力。

一些简单的定义如下
``` fortran
integer::a[*] !可以用于标量
integer,codimension(*)::b(10,10)!可以用于数组,可以使用codimension关键字
real,allocatable::c(:)[:] !可以用于可分配类型
type(submatrix):: a[*]  !可以用于自定义类型
complex(8)::a(10,10)[2,2:3,*] !也可以设置多维的，自定义边界
allocate(c(10)[*]) 
```
如果是可分配的，分配的时候**必须分配为**`[*]`,这是因为实际的image的数量是在运行的时候设置的，编译的时候并不确定。

## 运算
如果直接对一个变量进行赋值，那么表示对所有image都赋值。如果添加了`[]`则表示对指定的image赋值
``` fortran
program main
  implicit none
  integer::me[*]
  me=3
  write(*,*)this_image(),"me1=",me
  me[2]=100
  me[3]=me[4]+7
  write(*,*)this_image(),"me2=",me
end program main
```
``` sh
           1 me1=           3
           2 me1=           3
           2 me2=         100
           3 me1=           3
           3 me2=          10
           4 me1=           3
           4 me2=           3
           1 me2=           3
```
- `me[2:3]=[4,5]`这样的语法是**不合法**的
- 可以用`me=this_image()`为不同image设置存在规律的不同的数。

同时我们还可以用`if`结构来控制当前执行哪个image.
``` fortran
if (this_images()==1)then
    read(*,*)me
    do i=2,nums_images()
      me[i]=me
    end do
end if
```
## 同步

此时我们在`image 1`中修改了其他image的值 ，如果此时不考虑在if后面添加输出，我们发现程序并没有按照我们的想法运行。
``` fortran
integer::z[*],i
if (this_images()==1)then
    read(*,*)z
    do i=2,nums_images()
      z[i]=z
    end do
end if
write(*,*)"image=",this_images(),z
```
我们读入10
``` sh
 image=           3           0
 image=           4           0
 image=           2           0
10
 image=           1          10
```
这是因为，其他的image率先执行完毕了。所以此时我们需要对不同的image进行控制，此处就需要用到`sync all`,即所有的image都运行到此处时，程序再执行，提前运行到的先等待

``` fortran
integer::z[*],i
if (this_images()==1)then
    read(*,*)z
    do i=2,nums_images()
      z[i]=z
    end do
end if
sync all
write(*,*)"image=",this_images(),z
```
此时
``` sh
2
 image=           1           2
 image=           2           2
 image=           3           2
 image=           4           2
```
同时，还有精确控制单个images的同步语句`sync images(a)`,这里`a`可以时标量，也可以时一维数组，也可以是`*`,表示同步等待该线程。**为了避免死锁，执行`sync images()`语句时，images Q 等待images P的次数
要和images P 等待images Q的次数相等**。
