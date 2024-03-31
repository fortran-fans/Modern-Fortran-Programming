# 链表

此处我们只讨论最简单的单链表结构，其他更加复杂的数据结构读者可以自行编写

## node的定义
将指针与结构体结合，就可以创建动态的数据结构
``` fortran
module node_mod
  implicit none
  type node_t
    integer::x
    type(node_t),pointer::next=>null()
  end type node_t
end module node_mode
```

## 链表
可以一直为`next`指针分配内存，形成一个链，这样的数据结构称为链表

``` fortran
program main
  use node_mod
  implicit none
  type(node_t),pointer::tail=>null()
  type(node_t),target ::list
  integer::i
  list%x=0
  tail=>list
  do i=1,10
    allocate(tail%next)!分配内存
    tail=>tail%next    !指向末尾
    tail%x=i !赋值
  end do
  tail=>list
  do
    write(*,*)tail%x
    if(.not.associated(tail%next))exit !如果tail%next没分配，代表到了链表的末尾
    tail=>tail%next !指向下一个
  end do
end program main
```

## 使用`allocatable`定义递归结构
需要注意的是，也也可以使用`allocatable`来创建这样的结构
``` fortran
type node_t
    integer::x
    type(node_t),allocatable::next
end type node_t
```
但是两者略有不同，当有两个变量`type(node_t)::a,b`执行`a=b`的操作时，**对于`pointer`属性,`a%next`和`b%next`指向同一块内存，而对于`allocatable`属性`a%next`和`b%next`指向不同的内存**

- 注:`gfortran`在实现该功能的时候存在bug，所以均是指向同一块内存。`ifort,ifx,flang`没问题
- 通过重载赋值运算符`=`，可以避免这个bug
``` fortran
module test
    implicit none
    type node_t
        integer::x
        type(node_t),pointer::next=>null()
    end type node_t
    type node_a
        integer::x
        type(node_a),allocatable::next
    end type node_a
end module test

program main
    use test
    implicit none
    type(node_t)::t,t1
    type(node_a)::a,a1
    t%x=1
    allocate(t%next)
    t%next%x=2
    t1=t
    write(*,*)t1%next%x
    write(*,*)loc(t1%next),loc(t%next)!loc是编译器扩展语法，可以输出变量的地址，指针的地址相同
    
    a%x=1
    allocate(a%next)
    a%next%x=2
    a1=a
    write(*,*)a1%next%x
    write(*,*)loc(a1%next),loc(a%next)!可分配的地址不同
end program main
```

# 习题
- 尝试对链表实现插入操作
- (提高)尝试使用`allocatable`实现一个单链表，并实现插入操作(提示：注意使用`move_alloc`)
- (提高)使用自定义类型实现一个`list`类型，并绑定`append,insert,remove`操作，并实现析构函数

  
