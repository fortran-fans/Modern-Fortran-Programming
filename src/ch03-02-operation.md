# 运算符

本节主要介绍Fortran中的运算符

## 数(整型，浮点型，复数型)

### 数的四则运算，幂次
三种数类型有除了有`+-*/`四则运算之外，还有`**`幂运算，其规则和数学上的算数运算相似，运算的优先级为`**`最高，`*/`次之，`+-`最低，如果为混合算式，将遵循从左到右的运算顺序。

举例

``` fortran
program main
   implicit none
   real,parameter::pi=3.14159
   real::r,area,circumference
   r=2.0
   area=pi*r**2          !计算圆的面积
   circumference=2*pi*r  !计算圆的周长
   write(*,*)"area=",area
   write(*,*)"circumference=",circumference
end program main
```

``` sh
$ fpm run
Project is up to date
 area=   12.5663605
 circumference=   12.5663605
```
- **特别的，`**`是从右往左的运算顺序**，例如`2**3**3=2**(3**3)=2**27`
- 如果对运算的顺序没有把握，则多加小括号来保证运算顺序
- **整数的除法计算的是商**，即`3/2=1`而非`1.5`

### 数的比较
数的比较运算会返回一个逻辑类型，Fortran支持`> < == >= <= /=`的比较操作，其中`==`表示相等，**`/=`表示不相等**，一些语言使用`!=`来表示。

举例

``` fortran
program main
   implicit none
   write(*,*)1>2,2>=2,3==4,4/=3
   write(*,*)2.0>3.0
end program main
```

``` sh
$ fpm run
Project is up to date
 F T F T
 F
```
- 由于浮点数的精度问题，一般不建议用浮点数进行相等比较。比如判断x是否等于0，
一般采用`abs(x)<eps`,其中`abs(x)`是一个函数，它可以取一个数的绝对值，`eps`是自己定义的一个变量，用于给定精度。
- 复数不能用来比较

## 逻辑类型
逻辑类型之间也有自己的运算，分别为与`.and.` 或 `.or.` 非 `.not.` 异或`.neqv.` 同或 `.eqv.`,运算之后返回一个逻辑类型。

| 逻辑值A   | 逻辑值B   | `.and.`   | `.or.`    | `.neqv.`  | `.eqv.`   |
| :-:       | :-:       | :-:       | :-:       | :-:       | :-:       |
| `.true.`  | `.true.`  | `.true.`  | `.true.`  | `.false.` | `.true.`  |
| `.true.`  | `.false.` | `.false.` | `.true.`  | `.true.`  | `.false.` |
| `.false.` | `.true.`  | `.false.` | `.true.`  | `.true.`  | `.false.` |
| `.false.` | `.false.` | `.false.` | `.false.` | `.false.` | `.true.`  |

举例

``` fortran
program main
   implicit none
   real::x
   x=1.0
   write(*,*) x>0 .and. x<2
   write(*,*) x<0 .or.  x>1
end program main
```
``` sh
$ fpm run
Project is up to date
 T
 F
```
- 可以自己加小括号来保证运算顺序

## 字符串

### 字符串的拼接
字符串的运算基本运算只有字符串的拼接`//`

举例

``` fortran
program main
   implicit none
   write(*,*)"hello "//"world!" 
end program main
```
``` sh
$ fpm run
Project is up to date
 hello world!
```

字符串还有一些操作是通过内置函数来完成的，我们在函数的章节里再讨论

### 字符串的比较

字符串也有一系列的比较运算符，按照ascii码来进行比较，特别的

- Fortran字符串中的尾部空格不会计入比较，即`"abc"=="abc   "`,两者是相等的

## 一些内置函数
由于Fortran中有一部分内置功能是通过函数来实现的，所以我们在此处先介绍一些用于数值的内部函数。后面的章节中我们会具体介绍函数。

在数值运算中，输入一些值，返回一个值被称为函数。

- 三角函数和反三角函数
  - 弧度三角函数 :`sin(x),cos(x),tan(x),asin(x),acos(x),atan(x),atan2(y,x)`
  - 角度三角函数`(Fortran 2023)` :`sind(x),cosd(x),tand(x),asind(x),acosd(x),atand(x),atan2d(y,x)`
- 常用数学函数
  `exp(x),log(x),log10(x),min(x,y,....),max(x,y,....),mod(x,n)`,其中mod表示关于n取模。
- 特殊函数
  - bessel函数 :`bessel_j0(x),bessel_j1(x),bessel_jn(x),bessel_y0(x),bessel_y1(x),bessel_yn(x)`
  - 误差函数: `erf(x),erfc(x),gamma(x),log_gamma(x)`
- 转换函数
  - 整数转换函数:`int(n),nint(n)`
  - 浮点转换函数:`real(x),aint(n),anint(x)`
  - 复数转换函数:`cmplx(x,y,kind)`
- 字符串函数
  - 去除字符串空格:`trim(s)`
  - 字符串长度：`len(s),len_trim(s)`
  - 字符串查找函数: `index(str,sub)`

更多详细的介绍和示例可以在[fortran-lang 内置函数](https://fortran-lang.org/zh_CN/learn/intrinsics/)中查看

### 练习
- 根据三角形的边长`a,b,c`,利用海伦公式计算三角形的面积
- 使用内置函数，计算3个数的最大值
- 使用内置函数，计算3个数的中间值
