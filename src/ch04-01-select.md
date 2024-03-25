# select 选择语句

`select`语句可以对参数进行匹配判断，满足匹配条件的进入对应的`case`。 其中，只能用于**整型，字符串，逻辑型**

举例
``` fortran
select case(move)              ! move有wasd四种可能性
case("w");write(*,*)"上"       !使用;一行可以写多个语句，可读性更好
case("a");write(*,*)"左"
case("s");write(*,*)"下"
case("d");write(*,*)"右"
case default;write(*,*)"错误的方向" !默认的case,可以省略
end select
```

同时，`case` 语句支持指定多个条件进行匹配，也支持范围

``` fortran
!数字范围
select case(i)      
case(1:9)  ;write(*,*)"一位数" 
case(10:99);write(*,*)"两位数"
end select
!字符范围
select case(c)      
case('a':'z')  ;write(*,*)"小写字母" 
case('A':'Z')  ;write(*,*)"大写字母"
end select

select case(i)
case(2,3,5,7)  ;write(*,*)"质数"
case default   ;write(*,*)"不是质数"
end select
```

- 不支持`1:4:2`这类范围
