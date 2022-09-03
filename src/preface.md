# 序言

欢迎学习和使用[Fortran](https://fortran-lang.org/)！Fortran是一门主要应用于高性能数值计算与科学计算的程序语言，其特色在于灵活且强大的数组特性、易于编写并行数值算法。

## 关于Fortran

我们不打算在这里过多介绍Fortran的历史——毕竟你能很容易通过搜索引擎了解到。Fortran是一门「古老」的语言，古老到即使你以前未曾学习过Fortran，也可能听过别人对于古早Fortran代码的吐槽。但是Fortran也是一门「新」语言，因为新的语言标准仍在发布。Fortran的最新标准是Fortran 2018，下一个版本Fortran 202X也正在讨论中。

虽然Fortran属于「通用程序语言」<sup>[[wikipedia](https://en.wikipedia.org/wiki/Fortran)]</sup>，但是其主要应用的领域是数值计算。Fortran内置支持创建和使用数组，而且具有积累悠久的数值算法库，使得用户能轻松地编写数值计算程序。作为强类型语言，编译时对过程接口的严格检查，也保证了Fortran程序计算结果的可靠性。此外，Fortran具有良好的并行性，语法标准即支持了[Coarray](https://en.wikipedia.org/wiki/Coarray_Fortran)并行。你也可以通过其他并行API（[OpenMP](https://www.openmp.org/)、[MPI](https://www.mcs.anl.gov/research/projects/mpi/)、[CUDA Fortran](https://developer.nvidia.com/cuda-fortran)等）编写并行Fortran程序。

Fortran也有一些缺点：Fortran并不适合编写通用性的应用程序。用Fortran编写GUI程序是比较困难的，也缺少对于计算机底层的直接控制。不过Fortran提供了与C语言交互的接口。在实践中，可以使用其他语言构建程序主体，用Fortran编写计算密集的部分，两者之间通过C语言接口传递数据。

在实际开发中，Fortran还有如下的一些问题。Fortran标准只提供了一些内置过程与模块，并没有标准库。对于一些常用但是标准内并未提供的函数，用户可能要么自己编写实现，要么只能去寻找散落在各处的函数库。将代码构建为可执行程序也并非容易的事，尤其是当使用了其他函数库。如果你使用makefile，你可能需要手动维护源代码之间的依赖关系。

2019年，Ondřej Čertík和Milan Curcic等人建立了[fortran-lang](https://fortran-lang.org/)社区，并开始了[Fortran Standard Library](https://github.com/fortran-lang/stdlib)（stdlib）、[Fortran Package Manager](https://github.com/fortran-lang/fpm)（fpm）等项目的开发。虽然这些项目尚处于早期版本，但我们已经能窥见到它们的强大之处。尤其是fpm，提供了包管理以及项目构建功能。这使得我们能够方便地复用他人的代码，并构建自己的函数库或程序。

我们希望fortran-lang社区的发展与Fortran标准的进一步演化（比如提供泛型功能）能够使Fortran这门语言继续保持其生命力，让我们能使用Fortran继续开发数值计算程序。

## 关于本书

不得不承认的一点是，早期Fortran的影响力依然存在，不仅是代码遗产，也包括各种资料与书籍。我们编写这本书的一个目的，就是推广现代Fortran的特性以及开发工具。在这本书中，我们不会讲解任何过时的特性，而是着重于那些更为安全、更为友好的语言特性。

此外，我们希望本书并非单纯讲解Fortran的语言特性。我们认为真正重要的是帮助初学者学会编写程序、学会构建程序。因此本书也会简单介绍一些并非Fortran本身，但是编写程序时经常要接触到的概念与知识。需要注意的是，设计与构建程序框架的范式并非唯一，且各有优劣，所以我们无意也无法介绍所有的范式。本书将主要使用模块化的程序设计——这里的「模块」既表示抽象的功能单元，也表示Fortran的一种语言单元`module`。

为了让初学者们更加贴近开源社区，本书选择[gfortran](https://gcc.gnu.org/fortran/)编译器和fpm作为开发工具进行讲解。我们也希望你能够参与开源社区建设。

我们希望本书能教会你基础的Fortran语法，编写出结构化的程序。如果你在学习和编写Fortran中有任何疑问，欢迎加入「Fortran 初学」群（100125753）提出你的问题。

## 其他Fortran参考资料
* [Modern Fortran](https://www.manning.com/books/modern-fortran) - Milan Curcic
* [Quickstart Fortran Tutorial](https://fortran-lang.org/learn/quickstart) - fortan-lang
* [Fortran程序设计（第四版）](https://book.douban.com/subject/30388255/) - Stephen J. Chapman

