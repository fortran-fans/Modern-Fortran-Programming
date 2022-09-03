module Stern_Gerlach_experiment
    implicit none
    private
    public :: emit_atom

contains

    subroutine emit_atom()
        real :: raw_number
        integer :: spin ! 0代表spin up，1代表spin down

        call random_number(raw_number) ! raw_number的范围是[0,1)
        spin = nint(raw_number) ! 四舍五入得到0或1

        if (spin == 0) then ! 判断spin的值，若等于0，则执行下面语句
            write (*, *) "Emit an atom with spin up."
        else ! 否则执行这一部分
            write (*, *) "Emit an atom with spin down."
        end if

    end subroutine

end module
