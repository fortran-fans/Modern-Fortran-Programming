# 内置函数

Fortran中提供了大量的内置函数，熟练使用这些内置函数，可以有效提高写代码的效率。

所有的内置函数均可以在
- [`gfortran`的文档](https://gcc.gnu.org/onlinedocs/gcc-13.2.0/gfortran/Intrinsic-Procedures.html)
- [`ifort/ifx`的文档](https://www.intel.com/content/www/us/en/docs/fortran-compiler/developer-guide-reference/2023-0/language-summary-tables.html)
- [`fortran-lang`内置函数](https://fortran-lang.org/zh_CN/learn/intrinsics/)
中找到。

大部分用于数和数组类型的函数都是逐元函数，可以同时接收标量和数组。

## 一些易错点

内置函数中有一些易错点，有一些属于设计缺陷。

- `cmplx(a [,b] [,kind])`函数，`cmplx`函数用于构造一个复数，但是在实际的计算中，`cmplx(1.0_8,1.0_8)`的返回值并不是一个`complex(8)`的类型，而是一个`complex(4)`的类型，
  `cmplx(1.0_8,1.0_8,8)`这样才能返回合适的类型。
- `minloc(array [,dim] [,mask])`,`maxloc(array [,dim] [,mask])`,这两个函数用于返回数组中最小值，最大值的位置。当你传入的是一个一维数组的时候，
   它实际的返回值式`integer::idx(1)`类型，是一个数组而不是一个数。
  `minloc(array,dim=1)`这样写可以返回一个数。
- `dot_product(a,b)`这个函数用于计算两个一维数组的内积，需要注意的是，当传入的是`complex`类型的时候，它实际上计算的是\\(a^{H}b\\)而不是\\(a^{T}b\\)
- `reshape，mamtul`这些返回数组的内置函数，在`ifort/ifx`中优化很差，会造成栈溢出`stack overflow`,需要谨慎使用。

