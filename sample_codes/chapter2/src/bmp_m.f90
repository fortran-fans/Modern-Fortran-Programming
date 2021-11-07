module bmp_m
    use iso_fortran_env, only: i2 => int16, i4 => int32
    use iso_c_binding, only: c_char
    implicit none
    private
    public :: save_bmp

    integer(kind=i2), parameter :: BMP_HEADER_SIGNATURE = int(z'4D42', i2) ! 'BM' in ASCII

    type :: bmp_file_head
        integer(kind=i4) :: file_size ! size of BMP file, in byte (54 + pixel array)
        integer(kind=i2) :: reserve1 ! not used
        integer(kind=i2) :: reserve2 ! not used
        integer(kind=i4) :: offset_pixel ! starting position of pixel array
    end type

    type :: dib_head
        integer(kind=i4) :: dib_size ! size of DIB, 40 bytes
        integer(kind=i4) :: bmp_width ! image width, in pixel
        integer(kind=i4) :: bmp_height ! image height, in pixel
        integer(kind=i2) :: num_planes
        integer(kind=i2) :: bit_per_pixel ! only 24 is available
        integer(kind=i4) :: compress ! 0, do not compress
        integer(kind=i4) :: image_size ! size of BMP image, in byte
        integer(kind=i4) :: x_ppm ! x pixel per meter
        integer(kind=i4) :: y_ppm ! y pixel per meter
        integer(kind=i4) :: num_colors ! colors in color table
        integer(kind=i4) :: important_color
    end type

contains

    function save_bmp(image, file_name) result(stat)
        character(kind=c_char), dimension(:,:,:), intent(in) :: image
        character(len=*), intent(in) :: file_name
        logical :: stat
        !===================================================
        type(bmp_file_head) :: header
        type(dib_head) :: dib

        integer(kind=i4) :: row_size
        integer :: unit, ierr, i

        stat = .false.

        if (size(image, dim=1) /= 3) return

        header%offset_pixel = 54
        header%reserve1 = 0
        header%reserve2 = 0

        dib%bit_per_pixel = 24
        dib%bmp_width = size(image, dim=2)
        dib%bmp_height = size(image, dim=3)
        dib%compress = 0
        dib%dib_size = 40

        dib%important_color = 0
        dib%num_colors = 0
        dib%num_planes = 1
        dib%x_ppm = 3780
        dib%y_ppm = 3780
        
        row_size = ceiling(dib%bit_per_pixel * dib%bmp_width / 32., kind=i4) * 4
        dib%image_size = dib%bmp_height * row_size
        header%file_size = 54 + dib%image_size

        open(newunit=unit, file=file_name, iostat=ierr, access="stream", &
             form="unformatted", action="write", status="unknown")
        if (ierr /= 0) return

        write(unit) BMP_HEADER_SIGNATURE
        write(unit) header
        write(unit) dib

        do i = 0, dib%bmp_height-1
            write(unit, pos=header%offset_pixel+i*row_size+1) image(:,:,i+1)
        end do

        if (mod(dib%bmp_width, 4) /= 0) then
            write(unit, pos=header%offset_pixel+dib%bmp_height*row_size) char(0, c_char)
        end if

        close(unit)

        stat = .true.

    end function save_bmp

end module bmp_m
