# 函数
在实际的代码编写过程中，有一些操作是重复的，我们可以将它们提取出来，进行封装，在之后需要使用的时候直接调用。实现这类功能的结构叫做过程(procedure)。
在 Fortran中，具有返回值的过程称为函数(`function`)，不具有返回值的叫做子程序`subroutine`,在不混淆的情况下，我们可以将其统称为函数。

## 函数的定义

Fortran中，函数一般定义在`module`中，置于`contains`的后面，使用的时候，`use`这个`module`就可以导入这个函数。

首先用`fpm new my_func_mod`创建一个新的项目，然后将`module`文件放在`src/my_func_mod.f90`中
``` fortran
! 文件名src/my_func_mod.f90
module my_func_mod
    implicit none
contains
  function vector_norm(vec) result(norm)
    real, intent(in) :: vec(:) !这里vec(:)表示我们传入的是一个数组
    real :: norm
  
    norm = sqrt(sum(vec**2))
  
  end function vector_norm
end module my_func_mod

!文件名 app/main.f90
program main
  use my_func_mod
  implicit none
  real::a(3)
  a=[real::1.0,2.1,3.2]
  write(*,*)vector_norm(a)
end program main
```
运行之后
``` sh
$ fpm run
 3.95600796
```
其中`result`表示函数的返回值是什么，同时我们还需要在函数体中定义返回的类型和属性。 
- Fortran中有许多针对数组的内置函数，熟练使用他们，可以减少代码的冗余，提高效率，此处`sum`表示对数组进行求和，`sqrt`表示对元素进行开方

如果返回值**没有属性，只有类型**，则可以将其写在函数的开头。

将如下的两个文件也放在`module`中，即`vector_norm2`的后面
``` fortran
real function vector_norm2(vec) result(norm) !类型写在开头
  real, intent(in) :: vec(:)

  norm = sqrt(sum(vec**2))

end function vector_norm2

function double_vec(vec) result(vec2)
  real, intent(in) :: vec(:)
  real :: vec2(size(vec))   !可以返回数组，但是具有dimension属性，不能写在开头

  vec2=vec*2

end function double_vec
```
修改主函数

``` fortran
program main
  use my_func_mod
  implicit none
  real::a(3)
  a=[real::1.0,2.1,3.2]
  write(*,*)vector_norm(a)
  write(*,*)vector_norm2(a)
  write(*,*)double_vec(a)
end program main
```
``` sh
$ fpm run
  3.95600796    
  3.95600796    
  2.00000000       4.19999981       6.40000010
```
- `size` 函数返回数组的大小，如果是多维数组，返回的是**所有维度的乘积**

子过程的参数称为虚参，虚参一般会包含如下几个属性

| 虚参属性|说明|
|:-:|:-:|
|`intent(in)`|参数按照**引用**传递，拥有**只读**属性，不可修改|
|`intent(out)`|参数按照**引用**传递，拥有**写**属性|
|`intent(inout)`|参数按照**引用**传递，拥有**读写**属性|
|`value`|参数按照**值**传递，内部修改后不影响其原本的值|

- 在我们使用函数的过程中，尽量要保证函数的参数是`intent(in)`或者`value`的，这类过程也被称为**纯函数**，这类函数不存在副作用，编译器可以提供更好的优化。
- `intent(in)`也可以和`value`一起使用，此时值传递的虚参也**不可修改**。
- 如果不能保证纯函数，那可以使用我们下节提到的**子程序**
- 在代码中应当**总是使用**`intent`属性，这样可以更好的让编译器检查我们的代码

## 其他位置声明函数
除了在`module`的`contains`中定义函数，`program,function`以及我们接下来要学习的`subroutine`中都可以使用`contains`来定义函数，

``` fortran
program main
  implicit none
  real::a(3)
  a=[real::1.0,2.1,3.2]
  write(*,*)vec_norm(a)
contains
  real function vec_norm(a)result(res)
    real,intent(in)::a(:)
    res=norm2(a)!内置函数norm2
  end function vec_norm
end program main
```

但是这些位置定义的函数都**只在其对应的作用域内有效**，出了作用域就无法访问。



