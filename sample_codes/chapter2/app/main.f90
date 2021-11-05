program main
    use iso_fortran_env, only: real32
    use julia_set_m, only: generate_julia_set, draw_julia_set
    use save_julia_set_image, only: julia_set_image
    implicit none
    integer, parameter :: width = 80
    integer, parameter :: height = 50
    integer, dimension(height, width) :: julia_set
    complex(real32), parameter :: c = (-0.835, -0.2321)

    call generate_julia_set(julia_set, -1.5, 1.5, -1., 1., c, 1000)

    call draw_julia_set(julia_set)

    call julia_set_image(julia_set)

end program main
