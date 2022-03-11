program main

    integer a, b
    
    write (*, '(a)', advance='no') "Enter two numbers: "
    read (*, *) a, b
    
    write (*, '(a,i0)') "The maxium number is: ", max(a, b)

end program main
