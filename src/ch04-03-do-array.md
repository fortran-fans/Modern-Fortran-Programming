# 数组与循环
在前一节中，我们已经看到了隐式循环在数组中的应用，但是在实际的代码编写中，我们需要大量的编写多重循环。隐式循环和数组构造器的组合虽然在直觉上很方便，但是**会引入临时数组**，带来一定的性能损耗。

## 数组的列优先

前面我们已经提到了Fortran中的数组是列优先的。所谓列优先就是靠近数组左边的元素，在内存中离得更近。在我们使用多重循环的时候，对离得近的元素优先进行计算，将会带来一定的速度收益，
在计算机科学中，这种被称为**访存优化**。实际上,想要写出性能较高的Fortran程序，往往只需要注意**数组的列优先**,以及不要产生过多的**临时数组**。

一个简单的关于数组列优先优化的例子是矩阵的乘法，一般的矩阵乘法大家都会写成这样

``` fortran
  do i=1,n
    do j=1,n
      do k=1,n
        c(i,j)=c(i,j)+a(i,k)*b(k,j)
      end do
    end do
  end do
```
此时我们看到，内存循环为`k`,只有`b(k,j)`满足了列优先的条件，`c(i,j)`和`a(i,k)`都是`i`指标更靠前。所以我们可以尝试如下的优化
``` fortran
  do j=1,n
    do k=1,n
      do i=1,n
        c(i,j)=c(i,j)+a(i,k)*b(k,j)
      end do
    end do
  end do
```
我们可以尝试对比运行时间，来观察速度的变化。这里我们使用了内置的函数`system_clock`,第一个参数是当前时刻的时间(并不是绝对时间)，第二个参数是时间的颗粒度，用两个时刻的时间
相减，再除以颗粒度就是实际的用时(单位为s).
``` fortran
program main
  implicit none
  integer::i,j,k

  integer,parameter::n=1000
  real(8)::a(n,n),b(n,n),c(n,n)
  integer(8)::tic,toc,rate
  call random_number(a) !给数组填充随机数
  call random_number(b)
  call system_clock(tic,rate)
  c=0.0_8
  do i=1,n
    do j=1,n
      do k=1,n
        c(i,j)=c(i,j)+a(i,k)*b(k,j)
      end do
    end do
  end do
  call system_clock(toc,rate)
  write(*,*)"time(ijk)=",1.0_8*(toc-tic)/rate,"s" !注意此处为了避免整数除法，需要这样处理
  write(*,*)"c(n,n)=",c(n,n)
  call system_clock(tic,rate)
  c=0.0_8
  do j=1,n
     do k=1,n
        do i=1,n
           c(i,j)=c(i,j)+a(i,k)*b(k,j)
        end do
     end do
  end do
  call system_clock(toc,rate)
  write(*,*)"time(jki)=",1.0_8*(toc-tic)/rate,"s"
  write(*,*)"c(n,n)=",c(n,n)
end program main
```
我们使用release模式运行，release模式相对于之前的默认模式(通常是debug模式)，运行速度更快
``` sh
 time(ijk)=   1.3653479070000001      s
 c(n,n)=   240.96782832895653
 time(jki)=  0.16677901700000000      s
 c(n,n)=   240.96782832895653
```
可以看出，两者的运行时间大概相差了8倍。所以在实际的计算中，我们需要**注意数组的列优先带来的收益**。

## 列优先和矩阵的行列

**数组的列优先和矩阵的行列没有关系**，例如`a(1,2)`表示的就是矩阵的第一行第二列。所谓列优先只是数组存储和输出的时候按照自己的排布规则，和我们如何理解矩阵无关。

## 习题
- 写一个选列主元高斯消元法
- (提高)以列优先的规则写一个选列主元的高斯消元法，比较和行高斯消元法的速度
