# 过程的其他特性

## 过程的附加标识

- `pure` 纯过程

在函数或子程序的开头添加`pure`关键字，可以要求该过程是纯的，即其中没有副作用
``` fortran
pure real function vector_norm(vec) result(norm)
  implicit none
  real, intent(in) :: vec(:)

  norm = sqrt(sum(vec**2))

end function vector_norm
```

- `elemental` 逐元过程

逐元过程在定义的时候虚参只能是标量，但是在调用的过程中可以直接用于任意维数组。

``` fortran
module my_func_mod
  implicit none
contains
   elemental integer function gcd(m,n)result(res)
      integer,value::m,n
      do while(n>0)
         res=mod(m,n)
         m=n
         n=res
      end do
      res=m
   end function gcd
end module my_func_mod

program main
  use my_func_mod
  implicit none
  write(*,*)gcd(10,5)
  write(*,*)gcd([10,20],4)     !参数可以是数组和标量 
  write(*,*)gcd([10,20],[4,8]) !参数可以都是数组 
end program main
```

- `impure` 非纯过程

逐元过程默认是`pure`的，但是你可以使用`impure`关键字将其定义为非纯过程
``` fortran
module my_sub_mod
contains
   impure elemental subroutine print_vec(a)result(res)
      real,intent(in)::a
      write(*,*)a !带有输出，不是一个纯的过程
   end subroutine print_vec
end module my_sub_mod

program main
  use my_sub_mod
  implicit none
  call print(1.0)
  call print([1.0,1.1])
end program main
```
- `recursive` 递归过程

过程默认不具有递归属性，添加`recursive`关键字后，可以递归调用
``` fortran
   ! 斐波那契数列
   recursive integer function fib(n)result(res)
      integer,value::n
      if(n==1)then
        res=1
        return
      elseif(n==2)then
        res=2
        return
      else
        res=fib(n-1)+fib(n-2)
      end if
   end function fib
```

- 此处我们使用了`return`语句，注意Fortran中的`return`语句并不返回任何东西，所做的就是直接跳到子程序(函数)的末尾，然后退出。
  
## 关键字参数
Fortran中的子过程，它的参数可以通过关键字参数给定，即使用`虚参名=实参`的形式

## 可选参数

具有可选参数的虚参需要添加`optional`属性，使用 `present`内置函数检查参数是否存在
``` fortran
module my_func_mod
  implicit none
contains
    real function area(x,y)result(res)
      real,intent(in)::x
      real,intent(in),optional::y
      if(present(y))then
          res= x * y
      else
          res = x * x
      end if
    end function area
end module my_func_mod

program main
  use my_func_mod
  implicit none
  write(*,*)area(4.0) !正方形面积
  write(*,*)area(4.0,5.0) !长方形面积
  write(*,*)area(y=4.0,x=5.0) !可以使用关键字参数
end program main
```

