# 回调函数

当我们想把过程传递给过程的时候，需要限制传递过程的类型，此时就需要回调函数。Fortran提供了抽象接口(`abstract interface`)来实现这个功能，使用`procedure`关键字来定义虚参

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
