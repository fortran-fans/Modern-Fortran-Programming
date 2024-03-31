# 内存安全

现代Fortran在不引入指针的情况下，是一个内存安全的语言(但是Fortran编译器可能不安全)，但是还有一个简单的情况是无法处理的，即变量的别名。

在Fortran中，对于处于同一个作用域内的变量，一般不存在别名，但是Fortran中假设子程序的虚参也是不含别名的，这带来了一定的危险

一个典型的内存别名的例子是

``` fortran
program main
    implicit none
    integer::a,b
    a=2
    call test(a,a)
    write(*,*)a
    a=2
    b=0
    call test(a,b)
    write(*,*)b
contains
    subroutine test(a,b)
        integer,intent(in)::a
        integer,intent(inout)::b
        b=a+b
        b=b+b
    end subroutine test
end program main
```
此时,第一个例子`test`中传入的参数均为`a`,那么在`test`中`a`即使`intent(in)`属性又是`intent(inout)`属性。而在`test`的作用域中，变量`a`和`b`实际上表示的是同一块内存。这为我们实际的代码调试检查
带来了一定的难度，所以在实际的代码编写中，一定要杜绝这类代码。

同时，在使用我们前一节提到的`associate`的时候,要注意同时操作两个别名对数据进行处理的情况。
