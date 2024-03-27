![image](https://github.com/fortran-fans/Modern-Fortran-Programming/assets/64597797/318c2050-50b0-4c0f-a25e-ae2f145a7f8c)# 数组

在实际的程序编写过程中，我们有时候需要存储和操作一长串数字，而不是单个标量变量，例如存储100个粒子的位置，50个城市的经纬度。在计算机编程中，此类数据结构称为数组`array` 。

## 数组的声明

我们可以声明任意类型的数组，数组的声明需要用到`dimension`属性，这是我们学到的第二个属性

如果数组的大小在编写程序的时候就是已知的，那么就可以按照如下的方式定义，称为**静态数组**

``` fortran
program arrays
  implicit none

  ! 一维 integer 数组
  integer, dimension(10) :: array1

  ! dimension的语法糖，和上面的等价
  integer :: array2(10)

  ! 二维数组 
  real(8), dimension(10, 10) :: array3,array4

  ! 自定义数组的上标和下标
  real :: array5(0:9)
  real(8) :: array6(-5:5)

 ! 也可以使用parameter来定义
  integer,parameter::n=10
  real(8) :: array7(n)
  write(*,*)array7(3)   !输出单个数组元素
end program arrays
```
-  Fortran支持数组的最高维度是15维
-  Fortran的数组**下标从1**开始，且定义的时候是左闭右闭，和其他语言不同
-  此类静态数组声明时的大小只能是常数或者具有`parameter`属性的常量
-  数组的上下标**不能超过定义时的大小**，这类错误称为**数组越界**，在科学计算中十分常见。

## 数组的列优先

Fortran中数组是按照列优先的方式存储的，即**左边的指标更接近**
``` fortran
  integer::a(2,2)
```
排列的顺序为`a(1,1),a(2,1),a(1,2),a(2,2)`

## 数组初始化与构造器

数组的初始化有多种方式。

首先，Fortran支持将数组整体赋值，例如 `a=1`的形式就是将数组a中的元素全部赋值为1

其次就是数组构造器，语法是`[]`

同时数组还支持整体操作，包括运算符`+-*/`以及`**`，还有所有的逻辑运算符。对应的就是**数组的相应位置做对应的算数操作**，因此**数组整体操作的时候数组大小和维度必须相同，或者为标量**
``` fortran
program arrays
  implicit none
  integer :: array1(10)
  real::array2(3)
  array1=1 !整体初始化
  array1=[1,2,3,4,5,6,7,8,9,10] !数组构造器
  array2=[real::1.0,2.1,3.2]    !使用real::语句可以设定数组构造器的类型
  array2=array2+[1.0,1.0,2.0]   
  array2=array2+2.3             !也可以是标量 
end program arrays
```
注意 ,Fortran中**数组构造器只能产生一维数组**，如果要给多维数组赋值，则需要使用`reshape`函数，此时依旧是**列优先**.使用order关键字，可以进行**行优先**赋值

``` fortran
program arrays
  implicit none
  integer :: a(2,2),b(2,2)
  a=reshape([1,2,3,4],shape=[2,2])
  b=reshape([1,2,3,4],shape=[2,2],order=[2,1])
  write(*,*)"---------- a ------------"
  write(*,*)a(1,1),a(1,2)
  write(*,*)a(2,1),a(2,2)
  write(*,*)"---------- b ------------"
  write(*,*)b(1,1),b(1,2)
  write(*,*)b(2,1),b(2,2)
end program arrays
```

## 数组的切片

数组的切片使用的语法是`(start:end[:step])`，其中step可以是任意的整数，包括负数。

- 当`step=1`时，可以省略
- 当`end`表示的是数组末尾的时候，可以省略
- 当`start`表示的是数组开头的时候，可以省略
  
同时数组切片还可以和数组的整体操作运算结合起来，这为Fortran的数组提供了强大的语法糖。

``` fortran
program arrays
  implicit none
  integer :: array1(10)
  array1=[1,2,3,4,5,6,7,8,9,10]
  write(*,*)array1(1:10:2)               !输出所有的奇数位
  array1(6:)=array(:5)+array(1:10:2)     !利用数组切片加整体运算
  write(*,*)array1(10:1:-1)              !倒序输出
end program arrays
```

同时Fortran还支持使用数组作为数组的下标，**此时会产生临时数组**

``` fortran
program arrays
  implicit none
  integer :: array1(10),idx(3)
  array1=[1,2,3,4,5,6,7,8,9,10]
  idx=[4,6,5]
  write(*,*)array1(idx) 
end program arrays
```
## 可分配数组(动态数组)

有时候，数组的大小需要在计算中才能得出，前面使用的静态数组由于大小是固定的，有时候并不能满足相应的需求，这时候就需要动态数组。
定义动态数组需要用`allocatable`属性

``` fortran
program allocatable
  implicit none

  integer, allocatable :: array1(:)  ! 定义一维的可分配数组
  integer, allocatable :: array2(:,:)! 定义二维的可分配数组

  allocate(array1(10))   !分配大小
  allocate(array2(10,10))

  ! ...

  deallocate(array1) !释放
  deallocate(array2)

end program allocatable
```

- 可分配数组的大小可以不确定，但是维数必须确定
- 可分配数组分配之后就可以像普通数组一样使用，但是有一个**重分配**的机制，即`a=[1,2,3]`如果`a`是一个可分配数组，那么此时a就会重新分配内存，变成一个具有3个元素的数组

Fortran为带有可分配属性的变量提供了一个内置的子程序`call move_alloc(from,to)`,使用这个子程序，可以将`from`的分配属性**转移**到`to`,此时`from`将被释放

``` fortran
real,allocatable:: a(:),b(:)
a=[real::1,2,3]
write(*,*)allocated(a),allocated(b) !使用allocated函数检查分配属性
call move_alloc(a,b)
write(*,*)allocated(a),allocated(b)
write(*,*)b
```

## 数组常量

因为常量在定义之后就不能更改了，所以数组常量的定义可以不写具体的大小，只使用`(*)`代替

``` fortran
program allocatable
  implicit none
  integer,parameter::a(3)=[1,2,3]
  integer,parameter::b(*)=[1,2,3]  !使用*代替
  integer,parameter::c(0:*)=[4,5,6]!也可以自定义起点
end program allocatable
```

## 思考题
- 对二维数组使用数组切片操作，观察其输出
- 对二维数组使用数组作为下标，观察其输出
