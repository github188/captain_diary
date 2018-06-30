
https://news.html5.qq.com/share/768397206588282402?ch=060000&tabId=0&tagId=0&docId=768397206588282402&url=http%3A%2F%2Fkuaibao.qq.com%2Fs%2F20180106G000P100&clientWidth=360&dataSrc=&sc_id=xkeHgtC  这篇是写的不错的
volatile 关键字只能保证共享变量对各线程的可见性，也就是各个线程都能读到这个变量的最新值，但是并不能保证线程安全性，这是两个概念。需要办证安全性
一是在读写这个变量的时候加锁，各种锁都可以，另外可以用原子类。
https://www.cnblogs.com/zhengbin/p/5657707.html   这篇文章里面讲的很好，备战阿里，不错，小伙子，阿里不要你要谁

关于原子类，张孝祥讲的很好，atomic下面的原子类可以操作基本数据，数组中的基本数据，以及类中的基本数据。

atomic原子类操作类中的成员变量   

``` java
package com.teemo.rsa;
import java.util.concurrent.atomic.AtomicIntegerFieldUpdater;
public class AtomicIntegerFieldUpdaterDemo {
    class DemoData{
        public volatile int value1 = 1;
        volatile int value2 = 2;
        volatile int value3 = 3;
        volatile int value4 = 4;
    }
    AtomicIntegerFieldUpdater<DemoData> getUpdater(String fieldName) {
        return AtomicIntegerFieldUpdater.newUpdater(DemoData.class, fieldName);
    }
    void doit() {
        DemoData data = new DemoData();
        System.out.println("1 ==> "+getUpdater("value1").getAndSet(data, 10));
        System.out.println("3 ==> "+getUpdater("value2").incrementAndGet(data));
        System.out.println("2 ==> "+getUpdater("value3").decrementAndGet(data));
        System.out.println("true ==> "+getUpdater("value4").compareAndSet(data, 4, 5));
    }
    public static void main(String[] args) {
        AtomicIntegerFieldUpdaterDemo demo = new AtomicIntegerFieldUpdaterDemo();
        demo.doit();
    }
}
```





