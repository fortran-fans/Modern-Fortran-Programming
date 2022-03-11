program main

    integer i, res
    
    res = 1
    do i = 1, 10
        res = res*i
    end do
    
    write (*, *) "Factorial of 10: ", res

end program main
