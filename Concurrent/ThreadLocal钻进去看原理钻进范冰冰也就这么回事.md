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













