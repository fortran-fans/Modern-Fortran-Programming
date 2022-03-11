program main
    
    integer i
    integer :: ten(10) = [(i, i=1, 10)]

    write (*, *) "Factorial of 10: ", product(ten)

end program main
