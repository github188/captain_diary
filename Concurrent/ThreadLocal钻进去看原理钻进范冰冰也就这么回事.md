https://www.cnblogs.com/zhangjk1993/archive/2017/03/29/6641745.html
``` java
public class MultiThreadDemo2 {
	static ThreadLocal<String> stringThreadLocal = new ThreadLocal<>();
	public static void main(String[] args) {
	    Thread thread1 = new Thread(){
	        @Override
	        public void run() {
	            stringThreadLocal.set("threadName===>"+Thread.currentThread().getName());
	            System.out.println(this.getName()+" thread get the value:"+stringThreadLocal.get());
	        }
	    };
	    Thread thread2 = new Thread(){
	        @Override
	        public void run() {
	            stringThreadLocal.set("threadName===>"+Thread.currentThread().getName());
	            System.out.println(this.getName()+" thread get the value:"+stringThreadLocal.get());
	        }
	    };
	    Thread thread3 = new Thread(){
	        @Override
	        public void run() {
	            stringThreadLocal.set("threadName===>"+Thread.currentThread().getName());
	            System.out.println(this.getName()+" thread get the value:"+stringThreadLocal.get());
	        }
	    };
	    thread1.start();
	    thread2.start();
	    thread3.start();
	    System.out.println("main线程调用set方法之前："+stringThreadLocal.get());
	    stringThreadLocal.set("main 线程set的值");
	    System.out.println("main线程调用set方法之后："+stringThreadLocal.get());
	}
}
``` 
写这个案例1是想告诉你，ThreadLocal用起来其实很简单set，get就可以了，而且这两个方法是支持泛型的，可以用Object下面的任意类型参数。
在某个线程里面去set，然后在这个线程里面get，我靠，如果要存放多个值怎么办呢，用多个ThreadLocal实例就可以了。一个ThreadLocal实例只能存放一个值，
当然你可以把多个值放在一个集合里面，然后存这个集合。  2.ThreadLocal保证线程安全的原理是什么，他是以当前线程的实例作为key来将set进来的值存放在
一个ThreadLocalMap里面的
``` java
  /**
     * Sets the current thread's copy of this thread-local variable
     * to the specified value.  Most subclasses will have no need to
     * override this method, relying solely on the {@link #initialValue}
     * method to set the values of thread-locals.
     *
     * @param value the value to be stored in the current thread's copy of
     *        this thread-local.
     */
    public void set(T value) {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null)
            map.set(this, value);
        else
            createMap(t, value);
    }
```
但是 “副本”的含义体现在什么地方呢？  没瞧出来



``` java
public class MultiThreadDemo {
    public static class Number {
        private int value = 0;
        public void increase() throws InterruptedException {
            value = 10;
            Thread.sleep(10);
            System.out.println("increase value: " + value);
        }
        public void decrease() throws InterruptedException {
            value = -10;
            Thread.sleep(10);
            System.out.println("decrease value: " + value);
        }
    }
    public static void main(String[] args) throws InterruptedException {
        final Number number = new Number();
        Thread increaseThread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    number.increase();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
        Thread decreaseThread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    number.decrease();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
        increaseThread.start();
        decreaseThread.start();
    }
}
``` 
模拟ThreadLocal 
``` 
public class SimpleImpl {

    public static class CustomThreadLocal {
        private Map<Long, Integer> cacheMap = new HashMap<>();

        private int defaultValue ;

        public CustomThreadLocal(int value) {
            defaultValue = value;
        }

        public Integer get() {
            long id = Thread.currentThread().getId();
            if (cacheMap.containsKey(id)) {
                return cacheMap.get(id);
            }
            return defaultValue;
        }

        public void set(int value) {
            long id = Thread.currentThread().getId();
            cacheMap.put(id, value);
        }
    }

    public static class Number {
        private CustomThreadLocal value = new CustomThreadLocal(0);

        public void increase() throws InterruptedException {
            value.set(10);
            Thread.sleep(10);
            System.out.println("increase value: " + value.get());
        }

        public void decrease() throws InterruptedException {
            value.set(-10);
            Thread.sleep(10);
            System.out.println("decrease value: " + value.get());
        }
    }

    public static void main(String[] args) throws InterruptedException {
        final Number number = new Number();
        Thread increaseThread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    number.increase();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });

        Thread decreaseThread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    number.decrease();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });

        increaseThread.start();
        decreaseThread.start();
    }
}
``` 













