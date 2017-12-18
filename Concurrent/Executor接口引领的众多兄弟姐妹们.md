接口就像是女人，实现类就像是男人，抽象类就像是变性人，构成了面向对象这个自然和社会。
首先说，Exxcutors是个帮助类，就像Collections，Arrays
可以打开 Excutor这个接口的源码出来看看，它里面就一个抽象方法 execute()
```java
/** 
 * The {@code Executor} implementations provided in this package
 * implement {@link ExecutorService}, which is a more extensive
 * interface.  The {@link ThreadPoolExecutor} class provides an
 * extensible thread pool implementation. The {@link Executors} class
 * provides convenient factory methods for these Executors.
 *
 * <p>Memory consistency effects: Actions in a thread prior to
 * submitting a {@code Runnable} object to an {@code Executor}
 * <a href="package-summary.html#MemoryVisibility"><i>happen-before</i></a>
 * its execution begins, perhaps in another thread.
 *
 * @since 1.5
 * @author Doug Lea
 */
public interface Executor {

    /**
     * Executes the given command at some time in the future.  The command
     * may execute in a new thread, in a pooled thread, or in the calling
     * thread, at the discretion of the {@code Executor} implementation.
     *
     * @param command the runnable task
     * @throws RejectedExecutionException if this task cannot be
     * accepted for execution
     * @throws NullPointerException if command is null
     */
    void execute(Runnable command);
}
```

[https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/ExecutorService.html](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/ExecutorService.html)

https://www.cnblogs.com/MOBIN/p/5436482.html 这篇给我了很多灵感

线程池里面给进去Runnable和Callable实例有什么区别，前置有返回值，后者无返回值？
线程池实例执行exucte与submit方法有什么区别。前者与Runnable实例作为参数搭配使用，无返回结果，后者与Callable实例搭配有返回结果。
Executors这个类的newXXX方法方法可以返回ExcutorService下面的各种子类实例，一种1个线程，固定多个线程，可变线程数的CacheableThreadPoolExecutors
，还一个ScheduledThreadPoolExecutor，一共四个。
```
在JDK帮助文档中，有如此一段话：

“强烈建议程序员使用较为方便的Executors工厂方法Executors.newCachedThreadPool()（无界线程池，可以进行自动线程回收）、Executors.newFixedThreadPool(int)（固定大小线程池）Executors.newSingleThreadExecutor()（单个后台线程）

它们均为大多数使用场景预定义了设置。”
```
https://www.cnblogs.com/GarfieldEr007/p/5746362.html  这篇入门的文章也可以看一看
是这样，关于实现多线程的方法有哪几种，，枚举一下：
1.继承自Thread类，复写里面的run方法，然后调用start方法来启动该线程；
2.实现Runnable接口，重写里面的run方法，然后调用start方法来启动线程；
区别在于
实现Runnable接口比继承Thread类所具有的优势：

1）：适合多个相同的程序代码的线程去处理同一个资源

2）：可以避免java中的单继承的限制

3）：增加程序的健壮性，代码可以被多个线程共享，代码和数据独立

4）：线程池只能放入实现Runable或callable类线程，不能直接放入继承Thread的类

```  java
package com.example.multithread;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class CallableAndFuture {
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        ExecutorService executor = Executors.newSingleThreadExecutor();
        Future<String> future = executor.submit(new Callable<String>() {   //接受一上callable实例
            public String call() throws Exception {
                return "MOBIN";
            }
           /* Future<Integer> future = Executors.newSingleThreadExecutor().submit(new Callable<Integer>() {   //接受一上callable实例
            	@Override
                public Integer call() throws Exception {
                    return 3;
                }*/
        });
        System.out.println("任务的执行结果："+future.get());
    }
}
package com.example.multithread;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class CallableAndFuture {
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        ExecutorService executor = Executors.newSingleThreadExecutor();
        Future<String> future = executor.submit(new Callable<String>() {   //接受一上callable实例
            public String call() throws Exception {
                return "MOBIN";
            }
           /* Future<Integer> future = Executors.newSingleThreadExecutor().submit(new Callable<Integer>() {   //接受一上callable实例
            	@Override
                public Integer call() throws Exception {
                    return 3;
                }*/
        });
        System.out.println("任务的执行结果："+future.get());
    }
}


```

















