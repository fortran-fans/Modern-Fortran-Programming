# 回调函数

将函数作为参数传递给函数，这个功能称为回调函数，例如我们写一个数值积分，我们希望传入积分的上下界，以及一个一元函数。此时我们需要限制虚参的接口，防止别人传入一个多元函数。Fortran提供了抽象接口(`abstract interface`)来实现这个功能，使用`procedure`关键字来定义虚参

同样的，抽象接口也放在`module`中

``` fortran
module trapz_mod
  implicit none
  abstract interface
    real function func_1d(x)result(res)
      real,intent(in)::x
    end function func_1d
  end  interface
contains
  real function trapz(a,b,f) result(res)
    real,intent(in)::a,b
    procedure(func_1d)::f
    res=(f(a)+f(b))/2
  end function trapz

    real function mysin(x)result(res)
      real,intent(in)::x
      res=sin(x)
    end function mysin

    real function mycos(x)result(res)
      real,intent(in)::x
      res=cos(x)
    end function mycos
end module trapz_mod

program main
  use trapz_mod
  implicit none
  write(*,*)trapz(1.0,2.0,mysin)
  write(*,*)trapz(1.0,2.0,mycos)
end program main
```
``` sh
$ fpm run
   0.875384212    
   6.20777160E-02
```

## 习题
- 完成`trapz`数值积分，求解`sin(x)+cos(x)`在`[0,1]`上的积分
- 完成用于求解微分方程的Runge-Kutta方法`rk4` 计算
  $$y'=\frac{(e^{-x}-y)}{2},y(0)=0.5$$
  严格解为
  $$y=e^{-x}(1.5e^{\frac{x}{2}}-1)$$
