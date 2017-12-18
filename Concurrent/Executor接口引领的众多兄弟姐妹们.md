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


















