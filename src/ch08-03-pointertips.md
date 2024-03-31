# 指针的小技巧

## 数组的维数变换
Fortran中的数组在定义了维数之后，一般是不可变的。这是我们可以使用指针来为其设置一个别名

``` fortran
integer,target::a(4,4)
integer,pointer::pa(:)
pa(1:size(a))=>a !此时需要设置指针的宽度，且右边只能是一维或者连续的数组
```
这时候我们就获得了一个`a`的一维数组别名
``` fortran
integer::i
pa=[(i,i=1,16)]
write(*,*)pa(1::size(a,dim=1)) !获取对角项
```

如果在子程序或者函数中，我们则需要为数组设置`contiguous`关键字
```
program main
    real,target::a(10,10)
    integer::i
    real,pointer::p(:)
    a=reshape([(i,i=1,100)],shape(a)) !使用reshape为数组赋初值
    p=>diag(a) !使用指针获取对角项
    write(*,*)p
    p=[real::(i,i=111,120)] !修改对角项，此时p拿到的是对角项的引用，所以修改了之后，a的对角项也会改变
    do i=1,10
        write(*,*)a(i,i)
    end do
contains
    function diag(a)result(ptr)
        real,intent(in),target,contiguous::a(:,:) !需要加contiguous属性
        real,pointer::ptr(:)
        ptr(1:size(a))=>a
        ptr=>ptr(1::size(a,dim=1)+1) !取对角项
    end function diag
end program main
```
- `contiguous`属性对于数组的连续性做了强制要求，有时候**可以使得编译器做出更好的优化，提高代码运行速度**，因此在普通的含数组的过程中，也可以选择使用
## 思考题
- 如果传入的是数组的切片，那么还能用上述的方法修改吗

