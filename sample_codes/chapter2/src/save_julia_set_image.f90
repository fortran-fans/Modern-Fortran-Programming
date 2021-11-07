module save_julia_set_image
    use iso_fortran_env, only: int8
    use iso_c_binding, only: c_char
    use bmp_m, only: save_bmp
    implicit none
    private
    public :: julia_set_image

contains

    subroutine julia_set_image(set)
        integer, dimension(:,:), intent(in) :: set

        ! local variables
        character(kind=c_char), dimension(:,:,:), allocatable :: image
        integer :: pixel
        integer(kind=int8) :: red, green, blue
        integer :: width, height
        integer :: i, j

        height = size(set, dim=1)
        width = size(set, dim=2)

        allocate(image(3,width,height))

        do j = 1, height
            do i = 1, width
                ! the pixel order in BMP is from left to right, from bottom to top
                pixel = set(height-j+1,i)
                if (pixel > 1000) then
                    red = 0
                    green = 0
                    blue = 0
                else
                    red = int(min(255, pixel*10), kind=int8)
                    green = int(min(255, pixel*5), kind=int8)
                    blue = int(min(255, pixel*2), kind=int8)
                end if
                image(1,i,j) = char(red, kind=c_char)
                image(2,i,j) = char(green, kind=c_char)
                image(3,i,j) = char(blue, kind=c_char)
            end do
        end do

        if (.not. save_bmp(image, "julia_set.bmp")) write(*,*) "Error saving image"

    end subroutine julia_set_image

end module save_julia_set_image