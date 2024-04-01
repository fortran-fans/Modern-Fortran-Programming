# 模块的其他特性

我们也可以将变量存放在模块中。注意，模块中存放的**都是定义**，不能有执行语句。借助模块，我们可以对变量和过程进行封装，提高代码的可读性，一致性，可移植性。

模块中的变量和过程有三种属性`private(私有),public(公有),protected(保护，模块内可以修改，模块外只能访问不能修改)`，默认的属性是`public`

## 变量属性


``` fortran
module my_mod
  implicit none

  private                           !第一种定义方式全局其效果
  public::public_var, print_matrix  !第二种定义方式，只对限定的起效果

  real, parameter :: public_var = 2
  integer :: private_var
  integer,protected:: cnt=0          !第三种直接在声明时添加

contains

  subroutine print_matrix(A)
    real, intent(in) :: A(:,:)  !另一种数组传递的方式，可以省略一些虚参，并提供接口检查，推荐使用

    integer :: i

    cnt=cnt+1 !统计函数调用次数

    do i = 1, size(A,1)
      print *, A(i,:)
    end do

  end subroutine print_matrix

end module my_mod
```
## 其他的导入形式

``` fortran
program use_mod
  use my_mod !使用这个模块
  implicit none
  real :: mat(10, 10)

  mat(:,:) = public_var
  call print_matrix(mat)

end program use_mod
```

同时还可以显式导入

``` fortran
use my_mod, only: public_var
```
为了防止命名冲突，还可以使用别名导入

```fortran
use my_mod, only: printMat=>print_matrix
```


## 多文件

可以将不同的`module`保存到不同的文件中，这样在使用的时候可以编译对应的模块，也可以提高移植性。可以提前编写一些通用的模块，提高代码的复用程度。

例如，我们可以定义一个`parameter_mod`模块，用于封装一些常量，方便后续使用
```fortran
module parameter_mod
  implicit none
  integer,parameter     :: wp = 8
  real(wp),parameter    :: pi = acos(-1.0_wp)
  real(wp),parameter    :: e  = exp(1.0_wp)
  complex(wp),parameter :: imag1 = (0.0_wp, 1.0_wp)
  real(wp),parameter    :: hbar = 6.62607015e-34_wp
end module parameter_mod
```

- 现代的Fortran程序应当是**一个主程序和多个`module`组成**

