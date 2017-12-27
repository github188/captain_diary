https://www.cnblogs.com/zhengbin/p/5657707.html   这篇文章里面讲的很好，备战阿里，不错，小伙子，阿里不要你要谁

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
