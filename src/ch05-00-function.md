# 函数
在实际的代码编写过程中，有一些操作是重复的，我们可以将它们提取出来，进行封装，在之后需要使用的时候直接调用。实现这类功能的结构叫做过程(procedure)。
在 Fortran中，具有返回值的过程称为函数(function)

## 函数的定义

Fortran中，函数一般定义在`module`中，使用的时候，`use`这个`module`即可
``` fortran
! 内积
module my_func_mod
    implicit none
contains
  function vector_norm(vec) result(norm)
    real, intent(in) :: vec(:)
    real :: norm
  
    norm = sqrt(sum(vec**2))
  
  end function vector_norm
end module my_func_mod

program main
  use my_func_mod
  implicit none
  real::a(3)
  a=[real::1.0,2.1,3.2]
  write(*,*)vector_norm(a)
end program main
```

其中`result`表示函数的返回值是什么，同时我们还需要在函数体中定义返回的类型和属性。 

如果返回值**没有属性，只有类型**，则可以将其写在函数的开头。

``` fortran
! 内积
real function vector_norm(vec) result(norm) !类型写在开头
  real, intent(in) :: vec(:)

  norm = sqrt(sum(vec**2))

end function vector_norm

function double_vec(vec) result(vec2)
  real, intent(in) :: vec(:)
  real :: vec2(size(vec))   !可以返回数组

  vec2=vec*2

end function double_vec
```

子过程的参数称为虚参，虚参一般会包含如下几个属性

| 虚参属性|说明|
|:-:|:-:|
|`intent(in)`|参数按照**引用**传递，拥有**只读**属性，不可修改|
|`intent(out)`|参数按照**引用**传递，拥有**写**属性|
|`intent(inout)`|参数按照**引用**传递，拥有**读写**属性|
|`value`|参数按照**值**传递，内部修改后不影响其原本的值|

- 在我们使用函数的过程中，尽量要保证函数的参数是`intent(in)`或者`value`的，这类过程也被称为**纯函数**，这类函数不存在副作用，编译器可以提供更好的优化。
- 如果不能保证纯函数，那可以使用我们下节提到的**子程序**
- 在代码中应当**总是使用**`intent`属性，这样可以更好的让编译器检查我们的代码
