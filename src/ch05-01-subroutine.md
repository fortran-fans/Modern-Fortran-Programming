# 子程序

Fortran中不具有返回值的过程称为子程序(`subroutine`)，使用`call`语句调用这个子程序

子程序的定义和函数类似

``` fortran
!文件名 src/my_sub_mod.f90
module my_sub_mod
  implicit none
contains
  subroutine print_matrix(A)
    implicit none
    real, intent(in) :: A(:, :)
  
    integer :: i

    do i = 1, size(a,1)
      write(*,*)A(i, :)
    end do
  end subroutine print_matrix

  subroutine axpy(alpha,A,B)
    ! 计算 B=B+alpha*A
    implicit none
    real, intent(in) :: alpha
    real, intent(in) :: A(:, :)
    real, intent(inout) :: B(:, :)
    B=alpha*A+B
  end subroutine axpy
end module my_sub_mod

!文件名 app/main.f90
program main
  use my_sub_mod
  implicit none
  integer,parameter::n=4
  real::a(n,n),b(n,n)
  integer::i,j
  !使用循环赋值
  do i=1,n
    do j=1,n
       a(j,i)=real(i+j)
    end do
  end do
  !调用子程序
  call print_matrix(a)
  b=1.5
  call axpy(2.0,a,b)
  write(*,*)"--------------------"
  call print_matrix(b)
end program main
```
``` sh
$ fpm run
   2.00000000       3.00000000       4.00000000       5.00000000    
   3.00000000       4.00000000       5.00000000       6.00000000    
   4.00000000       5.00000000       6.00000000       7.00000000    
   5.00000000       6.00000000       7.00000000       8.00000000    
 --------------------
   5.50000000       7.50000000       9.50000000       11.5000000    
   7.50000000       9.50000000       11.5000000       13.5000000    
   9.50000000       11.5000000       13.5000000       15.5000000    
   11.5000000       13.5000000       15.5000000       17.5000000 
```


- 子程序的参数也具有`intent`属性，合理使用`intent`属性可以使得代码更加稳健
- 子程序中纯过程的定义更加灵活，参数可以是`intent(inout)`属性。如果函数不能写成纯的，可以考虑写成子程序
  
