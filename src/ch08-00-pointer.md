# 指针

当我们需要创建一些动态数据类型的时候，例如链表，二叉树，这时候就需要指针。

## 指向变量的指针

使用`pointer`关键字可以创建一个指针，使用`=>`可以指向对应的目标，此时要求被指的对象具有`target`属性，或者`pointer`属性
``` fortran
integer,target::x
integer,pointer::px=>null() !提供了null()指针将其指向空
px=>x
x=3
write(*,*)x,px
px=5
write(*,*)x,px
```
Fortran中的指针**并不是获取地址**，而是获取目标的引用。你可以理解成`px`是`x`的一个别名，当我们修改`px`和`x`带来的效果是一样的。

- Fortran中之所以要求被指针指向的变量具有`target`或者`pointer`属性是为了防止在优化过程中这个变量被优化掉

## 指向数组的指针

指向数组的指针需要给定维度，但是不能指定大小，只能用`:`表示。
``` fortran
integer,target::x(10)
integer,pointer::px(:) !只能定义为(:)
px=>x
x=3
write(*,*)px
px=>x(1:10:2) !可以指向数组切片
write(*,*)px
!px=>x([1,2,3])!错误，不能指向数组下标，因为数组下标返回的是临时数组
```
从这里可以看出Fortran中的数组在**定义的时候是连续的**，但是**在使用的过程中不一定是连续的**。

## 指针分配内存

我们也可以为指针分配内存，它和可分配数组的使用类似
``` fortran
integer,pointer::p
integer,pointer::pa(:,:)
allocate(p) !分配一个标量
allocate(pa(10,10))!分配一个数组
deallocate(p) !释放
deallocate(pa)
```
- 需要注意的是，**在使用函数的时候，作为局部变量，可分配变量离开了作用域会自动释放，但是指针不会**

## 内存泄漏

如果对指针进行了分配，但是同时有用它指向了其他的内存，那么就会出现内存泄漏。
``` fortran
integer,pointer::pa(:)
integer,target::a(3)
allocate(pa(3))
pa=[1,2,3]
a=[4,5,6]
pa=>a !内存泄漏
write(*,*)pa
write(*,*)a
```
- 为`pa`分配的内存没有其他的指针指向它，所以我们再无法访问到，但是它同时又没有被释放

## 指针悬垂
而另一种情况就是指针指向的内存被释放了，但是我们还是继续使用该指针，这种情况称为指针悬垂。
``` fortran
integer,pointer::pa(:)
integer,allocatable,target::a(:)
allocate(a(3),source=[1,2,3])
pa=>a
write(*,*)pa
deallocate(a)!pa现在指向了一块被释放的内存
write(*,*)pa 
```
所以，在对应的操作之后，我们需要同时将指针置空，有两种语法。
``` fortran
! 1.
nullify(pa)
! 2.
pa=>null()
```

## 关联(`associate`)
使用`associated`可以查看指针的关联属性
``` fortran
integer,pointer::pa(:)
integer,allocatable,target::a(:)
allocate(a(3),source=[1,2,3])
pa=>a
write(*,*)associated(pa) !检查pa是否被关联
write(*,*)associated(pa,a)!检查pa是否和a关联
```
Fortran2003中引入了`associate`语句，可以简化在代码编写过程中的临时变量问题，基本的语法是
``` fortran
integer::point(3)
integer::l
point=[1,2,3]
associate(x=>point(1),y=>point(2),z=>point(3))
l=x**2+y**2+z**2
end associate
```
需要注意的是，此时，如果`x=>p`的右边是变量，**那么`x`相当于是`p`的别名，修改了`x`，`p`也会随之改变**。如果右边是变量，那么相当于**自动创建一个临时变量**。
``` fortran
integer::a(10)
integer::i
a=[(i,i=1,10)]
associate(odd=>a(1:10:2))
    odd=odd*2
end associate
write(*,*)a
```
- 当我们具有一些比较层数比较深的自定义类型的时候，在代码中使用`associate`会大大提高代码的可读性
- 同一个语句中不能连续定义
``` fortran
associate(x=>point(1),x2=>x*x ) !错误
end associate
```
需要改成
``` fortran
associate(x=>point(1))
associate(x2=>x*x)
end associate
end associate
```
这是`associate`结构的不足之处
