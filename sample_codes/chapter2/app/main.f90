program main
    use Stern_Gerlach_experiment ! 引入模块，从而能够使用其中定义的变量及过程
    implicit none
    integer, parameter :: emission_times = 5 ! 实验的观察次数
    integer :: i

    do i = 1, emission_times
        call emit_atom()
    end do

end program
