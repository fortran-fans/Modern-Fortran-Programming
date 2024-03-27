# 回调函数

将函数作为参数传递给函数，这个功能称为回调函数，例如我们写一个数值积分，我们希望传入一个函数，上下界。此时我们需要限制虚参的接口，Fortran提供了抽象接口(`abstract interface`)来实现这个功能，使用`procedure`关键字来定义虚参

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

## 习题
- 完成`trapz`数值积分，求解`sin(x)+cos(x)`在`[0,1]`上的积分
