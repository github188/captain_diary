
为什么用线程池来做多线程卖票，怎么都不会库存超卖，怎么线程休眠都不会库存超卖，这很厉害。


这么写，是不是走偏了啊：
> new Thread(new RunnableScheduledFuture<String>() {}).start();
	
> new Thread(new RunnableFuture<String>() {}).start();

http://www.importnew.com/19011.html  这个例子觉得好  家纺公司和甲方工人以及外包员工


> 在了解将任务提交给线程池到任务执行完毕整个过程之前，我们先来看一下ThreadPoolExecutor类中其他的一些比较重要成员变量：
下面这个简单的例子很有意思
private final BlockingQueue<Runnable> workQueue;              //任务缓存队列，用来存放等待执行的任务
private final ReentrantLock mainLock = new ReentrantLock();   //线程池的主要状态锁，对线程池状态（比如线程池大小
                                                              //、runState等）的改变都要使用这个锁
private final HashSet<Worker> workers = new HashSet<Worker>();  //用来存放工作集
 
private volatile long  keepAliveTime;    //线程存货时间   
private volatile boolean allowCoreThreadTimeOut;   //是否允许为核心线程设置存活时间
private volatile int   corePoolSize;     //核心池的大小（即线程池中的线程数目大于这个参数时，提交的任务会被放进任务缓存队列）
private volatile int   maximumPoolSize;   //线程池最大能容忍的线程数
 
private volatile int   poolSize;       //线程池中当前的线程数
 
private volatile RejectedExecutionHandler handler; //任务拒绝策略
 
private volatile ThreadFactory threadFactory;   //线程工厂，用来创建线程
 
private int largestPoolSize;   //用来记录线程池中曾经出现过的最大线程数
 
private long completedTaskCount;   //用来记录已经执行完毕的任务个数
每个变量的作用都已经标明出来了，这里要重点解释一下corePoolSize、maximumPoolSize、largestPoolSize三个变量。

corePoolSize在很多地方被翻译成核心池大小，其实我的理解这个就是线程池的大小。举个简单的例子：

假如有一个工厂，工厂里面有10个工人，每个工人同时只能做一件任务。

因此只要当10个工人中有工人是空闲的，来了任务就分配给空闲的工人做；

当10个工人都有任务在做时，如果还来了任务，就把任务进行排队等待；

如果说新任务数目增长的速度远远大于工人做任务的速度，那么此时工厂主管可能会想补救措施，比如重新招4个临时工人进来；

然后就将任务也分配给这4个临时工人做；

如果说着14个工人做任务的速度还是不够，此时工厂主管可能就要考虑不再接收新的任务或者抛弃前面的一些任务了。

当这14个工人当中有人空闲时，而新任务增长的速度又比较缓慢，工厂主管可能就考虑辞掉4个临时工了，只保持原来的10个工人，毕竟请额外的工人是要花钱的。

这个例子中的corePoolSize就是10，而maximumPoolSize就是14（10+4）。

也就是说corePoolSize就是线程池大小，maximumPoolSize在我看来是线程池的一种补救措施，即任务量突然过大时的一种补救措施。

不过为了方便理解，在本文后面还是将corePoolSize翻译成核心池大小。

largestPoolSize只是一个用来起记录作用的变量，用来记录线程池中曾经有过的最大线程数目，跟线程池的容量没有任何关系。

下面我们进入正题，看一下任务从提交到最终执行完毕经历了哪些过程。

在ThreadPoolExecutor类中，最核心的任务提交方法是execute()方法，虽然通过submit也可以提交任务，但是实际上submit方法里面最终调用的还是execute()方法，所以我们只需要研究execute()方法的实现原理即可：






[http://blog.csdn.net/qq_31753145/article/details/50899119]http://blog.csdn.net/qq_31753145/article/details/50899119
上面这篇文章写的真是好，代码可以好好调试一下

-----------如何优雅的写多线程，就像用eclipse模板写Servlet一样自动生成那样行云流水---------
张孝祥，确实人才，这套多线程的视频讲的牛逼
首先 new Thread().start();  然后光标移动到Thread后面的括号，alt加斜杠，new Runnable（）自动生成这个括号里面的代码，自动加上run方法，
真的如行云流水。

你去看一下jdk5发行时间，2004年9月30日，那年我正在新一中念高三了，其实这是个很古老的东西。这个并发包，是doug
 lea 一手写出来得的。
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
>>传统的我们说多线程的实现，有两种方法，一种是thread构造器里面套一个继承thread的实现类，或者套一个实现runnable接口的实现类
如果是线程池，往里塞的是runnable的实现类或者callable的实现类，后者可以用future承载返回值。
你刚才在捷顺公司的那个想法，你说继承自Thread类，可以使用thread类里面的那些方法，其实这些是不对的，我们使用线程，在外面用thread构造器套了
一层，所以即便是实现Runnable接口也可以使用这些方法。不存在你说的那些问题。
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

package com.example.multithread;
import java.util.Date;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
public class HeartBeat {
    public static void main(String[] args) {
    	System.out.println("---------开始执行该代码块时间----"+new Date());
        ScheduledExecutorService executor = Executors.newScheduledThreadPool(1);
        Runnable task = new Runnable() {
            public void run() {
                System.out.println("HeartBeat........."+new Date()+"................");
            }
        };
        executor.scheduleAtFixedRate(task,10,3, TimeUnit.SECONDS);   //5秒后第一次执行，之后每隔3秒执行一次
    }
}

package com.example.multithread;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.ThreadPoolExecutor;

public class ThreadA {
	
	public static void main(String[] args) throws InterruptedException, ExecutionException {
		long t1 = System.currentTimeMillis();
		List al = new ArrayList();
		int c = 0 ; 
		/*for(int i=0;i<1000;i++) {
			c++;
			final int j = i ;
//			al.add(j);
			new Thread() {
				@Override
				public void run() {
					al.add(j);
					System.out.println(Thread.currentThread().getName());
				}
			}.start();
		}*/
		System.out.println(al);
		System.out.println(String.format(c+"向ArrayList加进去十万次，耗时{%s}", (System.currentTimeMillis()-t1)));
		
		
		for(int i=0;i<10;i++) {
			c++;
			final int j = i ;
//			al.add(j);
			new Thread(new Runnable() {
				@Override
				public void run() {
					al.add(j);
					System.out.println(Thread.currentThread().getName());
				}
			}).start();
			
			
			/*new Thread(new Callable() {
				@Override
				public Object call() throws Exception {
					al.add(j);
					System.out.println(Thread.currentThread().getName());
					return "";
				}
			
		}).start();*/
		}	
			ExecutorService es = Executors.newCachedThreadPool();
//			es.execute(command);
			Future<String> future = es.submit(new Callable<String>() {
				@Override
				public String call() throws Exception {
//					al.add(j);
					System.out.println(Thread.currentThread().getName());
					return "1111";
				}
			
		});
			System.out.println(future.get());
		System.out.println(al);
		System.out.println(String.format(c+"向ArrayList加进去十万次，耗时{%s}", (System.currentTimeMillis()-t1)));
	}
}



```
还是我湖北老乡这课程牛掰，
www.icoolxue.com/album/show/109   这课程在11年录制的，依然牛逼
















