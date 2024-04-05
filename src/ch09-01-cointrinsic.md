# coarray的内置函数

coarray 中提供了内置函数用于处理不同image之间的数据交换问题。

## `co_reduce`

`co_reduce`可以表示对不同images的数据做归约操作，支持自定义运算(关于规约的定义，可以查看内置函数一节中，`reduce`函数的介绍)。

``` fortran
module pure_func_mod
  implicit none
contains
  pure real function pow_add(a,b)result(c)
      real,intent(in)::a,b
      c=sqrt(a**2+b**2)
  end function pow_add
end module pure_func_mod

program main
  use pure_func_mod,only:pow_add
  implicit none
  real::a[*]
  a=this_image()
  call co_reduce(a,pow_add)
  write(*,*)this_image(),a
end program main
```
其中的`operation`是一个自定义的函数，**且必须是纯函数**

``` sh
$ fpm run --compiler="caf" --runner="cafrun -n 4"
           3   5.47722578
           4   5.47722578
           1   5.47722578
           2   5.47722578
```
同时`co_reduce`还支持`result_images`选项，表示只将结果输出到对应的imgaes

- 练习：编写函数`f(a,b)=lcm(a,b)`，将结果输出到编号为2的image, 并验证结果是否正确，此处`lcm`指的是最小公倍数。
  
同时直接提供了使用较多的几类函数`co_max,co_min,co_sum`，不需要自行编写函数。

## `co_broadcast`

这是广播函数，用于将对应image的值广播到所有的image上
``` fortran
program main
  use pure_func_mod,only:pow_add
  implicit none
  real::a[*]
  if(this_image()==1)then
      read(*,*)a
  end if
  call co_broadcast(a, source_image=1)
  write(*,*)this_image(),a
end program main
```
``` sh
10
           4   10.0000000
           1   10.0000000
           2   10.0000000
           3   10.0000000
```
