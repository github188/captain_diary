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

















