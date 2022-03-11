program main

    real :: PI = acos(-1.0)
    real r
    
    write(*, "(a)", advance='no') "Enter the radius of the circle: "
    read(*, *) r
    
    write(*, "(a,f6.2)") "The area of the circle is: ", PI*r**2

end program main
