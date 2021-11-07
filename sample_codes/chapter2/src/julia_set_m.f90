module julia_set_m
    use iso_fortran_env, only: real32
    implicit none
    private
    public :: generate_julia_set, draw_julia_set

contains

    function julia_point(z0, c, max_iter) result(n)
        complex(real32), intent(in) :: z0
        complex(real32), intent(in) :: c
        integer, intent(in) :: max_iter
        integer :: n

        ! local variables
        complex(real32) :: z

        z = z0
        do n = 1, max_iter
            z = z**2 + c
            if (abs(z) > 2.) exit ! z must diverge when |z| > 2
        end do

    end function julia_point


    subroutine generate_julia_set(set, xmin, xmax, ymin, ymax, c, max_iter)
        integer, dimension(:,:), intent(inout) :: set
        real(real32), intent(in) :: xmin, xmax
        real(real32), intent(in) :: ymin, ymax
        complex(real32), intent(in) :: c
        integer, intent(in) :: max_iter

        ! local variables
        integer :: i, j
        real(real32) :: xstep, ystep
        complex(real32) :: z

        xstep = (xmax - xmin) / (size(set, dim=2) - 1)
        ystep = (ymax - ymin) / (size(set, dim=1) - 1)

        do j = 1, size(set, dim=1)
            do i = 1, size(set, dim=2)
                z = complex(xmin + (i - 1) * xstep, ymin + (j - 1) * ystep)
                set(j, i) = julia_point(z, c, max_iter)
            end do
        end do

    end subroutine generate_julia_set


    subroutine draw_julia_set(set)
        integer, dimension(:,:), intent(in) :: set

        ! local variables
        character(len=size(set, dim=2)) :: row
        integer :: i, j

        do j = 1, size(set, dim=1)
            do i = 1, size(set, dim=2)
                select case (set(j, i))
                    case (1)
                        row(i:i) = ' '
                    case (2:5)
                        row(i:i) = '.'
                    case (6:10)
                        row(i:i) = ':'
                    case (11:15)
                        row(i:i) = '*'
                    case (16:20)
                        row(i:i) = 'x'
                    case (21:)
                        row(i:i) = '#'
                    case default
                        write(*, "(a)") "Error: wrong value in set"
                        stop
                end select
            end do
            write(*, "(A)") row
        end do

    end subroutine draw_julia_set

end module julia_set_m