# 文件读写

## 文件打开关闭

Fortran使用`open`语句打开文件，其中有两个必填的参数，一个为`unit`，表示文件的通道号，作为文件的唯一标识，另一个为`file`表示文件名。最后使用`close`关闭文件。

``` fortran
  open(unit=10,file="1.txt")!unit关键字可以省略
  close(10)
```
- 文件通道号一般设置大于10的数
- Fortran2003提供了一个新的参数，称为`newunit`,可以让编译器帮你自动设置文件通道号，不过带来的不便之处就是你可能需要在子程序中引入这个虚参。
  
``` fortran
  integer::myunit
  open(newunit=myunit,file="1.txt")!newunit不能省略
  close(myunit)
```

如果要设置文件具有只读权限，必须使用指定关键字 `status` 和 `action`

``` fortran
integer :: io
open(newunit=io, file="log.txt", status="old", action="read")
close(io)
```

如果要打开一个二进制文件，则需要使用`form` 和`access`关键字

``` fortran
integer :: io
open(newunit=io, file="log.bin", form="unformatted",access="stream")
close(io)
```
- 二进制文件中，元素是按照其二进制表示逐个保存的，没有分隔符

## 文件读写

使用`read`来读入文件，第一个参数是文件的通道号，第二个参数是文件的格式
``` fortran
integer :: io
open(newunit=io, file="log.txt", status="old", action="read")
read(io,*)a,b
close(io)
```
read语句有一个很有用的选项是`iostat`，它表示当前的读取是否正常，当其等于0时表示读取正常，否则表示读取不正常。我们可以使用这个选项来判断读取是否错误，或者是否遇到了文件末尾。

``` fortran
integer  :: io,ios,n
character:: line
open(newunit=io, file="log.txt", status="old", action="read")
n=0
do
  read(io,*,iostat=ios)line
  if(ios/=0)exit !读取不正常，跳出循环
  n=n+1
end do
close(io)
write(*,*)"linenum",n
```
例如通过这样读取文件，就可以判断一个文件的行数。
- 上述方法在文件中有空行的时候就失效了，如果要计算空行的话，则需要下一节的格式化读取。

使用`write`来写入文件，第一个参数是文件的通道号，第二个参数是文件的格式
``` fortran
integer :: io
open(newunit=io, file="log.txt")
write(io,*)a,b
close(io)
```

当你读写的文件是二进制文件的时候，就不需要填写格式参数

``` fortran
integer :: a(100,100) !a是一个数组
open(10, file="r.bin", form="unformatted",access="stream")
open(11, file="w.bin", form="unformatted",access="stream")
read(10)  a
write(11) a+100
close(10)
close(11)
```
- 二进制文件的**读写速度很快**

