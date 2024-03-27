# 过程绑定

Fortran2003开始支持过程绑定，将子程序或者函数与对应的类型相关联，使用的方法和访问成员类似。这样的做法可以提高代码的一致性。

## 过程绑定的语法

过程绑定中， 对应子过程的虚参声明需要使用`class`关键字。同时在类型的定义中使用`procedure`关键字将其绑定,使用`contains`将类型和函数分开。

## 析构函数

程序运行结束之后，这个对象需要释放，此时使用`final`关键字可以指定一个函数为析构函数。当释放的时候就会调用这个函数。

``` fortran
module vector_mod
  implicit none
  type vector_t
    real,allocatable::x(:)
    integer::capacity
    integer::size
  contains
    procedure,pass:: init => vector_init
    procedure,pass:: append => vector_append
    final :: vector_final
  end type vector_t
contains
  subroutine vector_init(this,n)
    class(vector_t),intent(inout)::this
    integer,intent(in)::n
    allocate(this%x(n))
    this%size=0
    this%capacity=n
  end subroutine vector_init

  subroutine vector_append(this,val)
    class(vector_t),intent(inout)::this
    real,intent(in)::val
    this%size=this%size+1
    this%x(this%size)=val
  end subroutine vector_append

  subroutine vector_final(this)
    type(vector_t),intent(inout):: this !此处是type 不是class
    if(allocated(this%x))deallocate(this%x) !释放可分配数组
    this%size=0
    this%capacity=0
    write(*,*)"call final" 
  end subroutine vector_final
end module vector_mod

program main
  use vector_mod
  implicit none
  block
    type(vector_t)::v
    call v%init(10)
    call v%append(1.0)
    call v%append(2.0)
    write(*,*)v%x(1:v%size)
  end block !离开作用域时会调用析构函数
  write(*,*)"done"
end program main
```

- `pass`关键字用来指定在调用的过程中，被调用的类型会**自动传递为第一个虚参**，与之对应的还有`nopass`，不自动传递
- `pass(this)`关键字也可以带具体的参数，用于指定哪个虚参被自动传递。当你的函数中有多个虚参都是当前类型的时候，你可以指定任意一个。
- 使用`=>`可以为绑定的过程重命名。
- 被绑定的变量名尽量使用`this`或者`self`(与其他语言的习惯相符)

## 习题
- vector的`append` 函数并没有考虑超过`capacity`的情况。重写这个函数，使其可以在元素超出的时候自动扩容。
- (附加题)使用`move_alloc`子程序完成上述功能。
- 使用我们之前提到的函数重载功能重载`size`函数，使得`size(v)`返回`v%size`


