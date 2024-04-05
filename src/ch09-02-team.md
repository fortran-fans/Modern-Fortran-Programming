# team 分组并行

有时候我们需要为不同的image分配不同的任务，此时team是一个简单的方式。

## 构建team

内置模块`iso_fortran_env`中定义了类型`team_type`，通过`form team`语句就可以为每个image分组,通过`team_number`函数可以查看当前的image属于哪一个team

``` fortran
program main
   use iso_fortran_env
   implicit none
   type (team_type) :: myteam
   integer ::teamid,id,np
   id=this_image()
   np=num_images()
   teamid=1
   if(id > np/2)teamid=2
   form team(teamid,myteam)
   write(*,*)"this image=",id,"team number",team_number(myteam)
end program main
```
``` sh
$ fpm run --compiler="caf" --runner="cafrun -n 4"
 this image=           3 team number           2
 this image=           4 team number           2
 this image=           1 team number           1
 this image=           2 team number           1
$ fpm run --compiler="caf" --runner="cafrun -n 6"
 this image=           6 team number           2
 this image=           1 team number           1
 this image=           2 team number           1
 this image=           3 team number           1
 this image=           4 team number           2
 this image=           5 team number           2
```
## team中进行计算

通过 `change team`语句可以将针对team进行计算,再该结构中**`this_image()`和`num_images()`对应的是各自team的编号，且内置函数计算的也是team内的结果**

``` fortran
program main
   use iso_fortran_env
   implicit none
   type (team_type):: myteam
   integer::teamid,id,np
   real(8)::a[*]
   id=this_image()
   np=num_images()
   teamid=1
   if(id > np/2)teamid=2
   a=id
   form team(teamid,myteam)
   change team(myteam)
      call co_sum(a,result_image=1)
   end team
   write(*,*)"this image=",id,"team number",team_number(myteam),"a=",a
end program main
```
``` sh
$ fpm run --compiler="caf" --runner="cafrun -n 4"
 this image=           1 team number           1 a=   3.0000000000000000     
 this image=           2 team number           1 a=   2.0000000000000000     
 this image=           3 team number           2 a=   7.0000000000000000     
 this image=           4 team number           2 a=   4.0000000000000000 
```
- 注意此时结果都在对应team的第一个image上

同时 `change team`还支持对不同的team执行不同的操作

如下是一个对不同image进行分组，然后在team1中使用矩形法，team2中使用梯形法求解
$$\int_0^{\pi} sin(x) dx = 2$$
的例子
``` fortran
program main
   use iso_fortran_env
   implicit none
   type(team_type)::myteam
   real(8),parameter::pi=acos(-1.d0)
   integer::teamid,i,id,np
   real(8)::area,delta
   integer,parameter::n=100
   id=this_image()
   np=num_images()
   teamid=1
   if(id > np/2)teamid=2
   area=0
   delta=pi/n
   form team(teamid,myteam)
   change team(myteam)
   select case(team_number())
   case(1)
      do i=this_image(),n-1,num_images()
         area=area+sin(i*delta)
      end do
      area=area*delta
      call co_sum(area,result_image=1)
      if(this_image()==1)write(*,*)"rect ",area
   case(2)
      do i=this_image(),n,num_images()
         area=area+sin((i-0.5)*delta)
      end do
      area=area*delta
      call co_sum(area,result_image=1)
      if(this_image()==1)write(*,*)"trapz",area
   end select 
   end team
end program main
```
``` sh
$ fpm run --compiler="caf" --runner="cafrun -n 4"
 trapz   2.0000822490709860     
 rect    1.9998355038874434 
```

