可以这样总结吗，一个是正着数，一个倒着数。  不是，可以都将他们看做倒着数，不同之处
在于倒数锁有一个管理者，法号司令者，其实这个没什么卵用，对吧，不用裁判，运动员所有人准备好了就出发，没毛病。
假设这个场景，运动员都就绪后，裁判扣动发令枪运动员开跑。
用CyclicBarrier 一个锁就搞定（不需要裁判，各运动员线程是可以自觉遵守规则的），用倒数锁，需要用两次。裁判等运动员一次，
运动员还要等裁判一次。 另外，前者只要在线程里面调用一个await()方法就可以了。 后者掉了countDown（），还要调await(),忒麻烦了点。
哪还有一个问题，在于有没有哪些场景是倒数锁搞的定，而CyclicBarrier搞不定的？

``` java
package concurrent;
import java.util.Random;
import java.util.concurrent.CyclicBarrier;
public class CyclicBarrierDemo {
	public static void main(String[] args) throws Exception {
		final CyclicBarrier cb = new CyclicBarrier(100);
		final CyclicBarrier cb2 = new CyclicBarrier(100);
		for(int i=1;i<101;i++){
			new Thread(new Runnable() {
				public void run() {
					try {
					Thread.sleep(new Random().nextInt(200));
					System.out.println("该运动员即将准备就绪:"+Thread.currentThread().getName());
					cb.await();//cb1 计数器加1,加到100的时候自动开始执行后面的语句
					System.out.println("该运动员从起跑线出发了"+Thread.currentThread().getName());
					Thread.sleep(new Random().nextInt(100));
					System.out.println("该运动员已经到达终点线，等待所有人到达后报告成绩:"+Thread.currentThread().getName());
					cb2.await();//cb12计数器加1,加到100的时候自动开始执行后面的语句
					System.out.println("该运动员报告自己的成绩"+Thread.currentThread().getName());
					}catch (Exception e) {
						e.printStackTrace();
					}
				}
			}).start();
		}
	}
}

``` javva
package concurrent;
import java.util.Random;
import java.util.concurrent.CountDownLatch;
public class CountDownLatchDemo {
	public static void main(String[] args) throws Exception {
		final CountDownLatch cd1 = new CountDownLatch(100);
		final CountDownLatch cd2 = new CountDownLatch(1);
		final CountDownLatch runOver = new CountDownLatch(100);
		final CountDownLatch report = new CountDownLatch(1);
		for(int i=1;i<101;i++){
			new Thread(new Runnable() {
				public void run() {
					try {
					Thread.sleep(new Random().nextInt(200));
					System.out.println("该运动员已到达起跑线,准备好了:"+Thread.currentThread().getName());
					cd1.countDown();
					cd2.await();
					System.out.println("从起跑线出发了"+Thread.currentThread().getName());
					Thread.sleep(new Random().nextInt(100));
					System.out.println("该运动员已到达终点,等待裁判通知报告成绩:"+Thread.currentThread().getName());
					runOver.countDown();
					report.await();
					System.out.println("报告自己成绩"+Thread.currentThread().getName());
					}catch (Exception e) {
						e.printStackTrace();
					}
				}
			}).start();
		}
		cd1.await();
		System.out.println("所有运动员已经准备好了，裁判扣动扳机");
		cd2.countDown();
		runOver.await();
		System.out.println("~~~~~裁判员等待所有运动员~都已经跑完了~~~~~~~");
		report.countDown();
		
	}
}

```    

该运动员已到达起跑线,准备好了:Thread-2
该运动员已到达起跑线,准备好了:Thread-6
该运动员已到达起跑线,准备好了:Thread-75
该运动员已到达起跑线,准备好了:Thread-44
该运动员已到达起跑线,准备好了:Thread-38
该运动员已到达起跑线,准备好了:Thread-69
该运动员已到达起跑线,准备好了:Thread-23
该运动员已到达起跑线,准备好了:Thread-19
该运动员已到达起跑线,准备好了:Thread-39
该运动员已到达起跑线,准备好了:Thread-43
该运动员已到达起跑线,准备好了:Thread-22
该运动员已到达起跑线,准备好了:Thread-3
该运动员已到达起跑线,准备好了:Thread-4
该运动员已到达起跑线,准备好了:Thread-68
该运动员已到达起跑线,准备好了:Thread-49
该运动员已到达起跑线,准备好了:Thread-30
该运动员已到达起跑线,准备好了:Thread-41
该运动员已到达起跑线,准备好了:Thread-24
该运动员已到达起跑线,准备好了:Thread-52
该运动员已到达起跑线,准备好了:Thread-15
该运动员已到达起跑线,准备好了:Thread-87
该运动员已到达起跑线,准备好了:Thread-53
该运动员已到达起跑线,准备好了:Thread-40
该运动员已到达起跑线,准备好了:Thread-97
该运动员已到达起跑线,准备好了:Thread-81
该运动员已到达起跑线,准备好了:Thread-47
该运动员已到达起跑线,准备好了:Thread-46
该运动员已到达起跑线,准备好了:Thread-27
该运动员已到达起跑线,准备好了:Thread-11
该运动员已到达起跑线,准备好了:Thread-18
该运动员已到达起跑线,准备好了:Thread-1
该运动员已到达起跑线,准备好了:Thread-31
该运动员已到达起跑线,准备好了:Thread-32
该运动员已到达起跑线,准备好了:Thread-71
该运动员已到达起跑线,准备好了:Thread-70
该运动员已到达起跑线,准备好了:Thread-91
该运动员已到达起跑线,准备好了:Thread-0
该运动员已到达起跑线,准备好了:Thread-78
该运动员已到达起跑线,准备好了:Thread-62
该运动员已到达起跑线,准备好了:Thread-65
该运动员已到达起跑线,准备好了:Thread-21
该运动员已到达起跑线,准备好了:Thread-58
该运动员已到达起跑线,准备好了:Thread-36
该运动员已到达起跑线,准备好了:Thread-84
该运动员已到达起跑线,准备好了:Thread-26
该运动员已到达起跑线,准备好了:Thread-54
该运动员已到达起跑线,准备好了:Thread-28
该运动员已到达起跑线,准备好了:Thread-94
该运动员已到达起跑线,准备好了:Thread-77
该运动员已到达起跑线,准备好了:Thread-98
该运动员已到达起跑线,准备好了:Thread-96
该运动员已到达起跑线,准备好了:Thread-89
该运动员已到达起跑线,准备好了:Thread-14
该运动员已到达起跑线,准备好了:Thread-7
该运动员已到达起跑线,准备好了:Thread-99
该运动员已到达起跑线,准备好了:Thread-86
该运动员已到达起跑线,准备好了:Thread-25
该运动员已到达起跑线,准备好了:Thread-61
该运动员已到达起跑线,准备好了:Thread-80
该运动员已到达起跑线,准备好了:Thread-83
该运动员已到达起跑线,准备好了:Thread-48
该运动员已到达起跑线,准备好了:Thread-9
该运动员已到达起跑线,准备好了:Thread-79
该运动员已到达起跑线,准备好了:Thread-37
该运动员已到达起跑线,准备好了:Thread-34
该运动员已到达起跑线,准备好了:Thread-92
该运动员已到达起跑线,准备好了:Thread-90
该运动员已到达起跑线,准备好了:Thread-5
该运动员已到达起跑线,准备好了:Thread-57
该运动员已到达起跑线,准备好了:Thread-74
该运动员已到达起跑线,准备好了:Thread-17
该运动员已到达起跑线,准备好了:Thread-13
该运动员已到达起跑线,准备好了:Thread-93
该运动员已到达起跑线,准备好了:Thread-10
该运动员已到达起跑线,准备好了:Thread-33
该运动员已到达起跑线,准备好了:Thread-95
该运动员已到达起跑线,准备好了:Thread-42
该运动员已到达起跑线,准备好了:Thread-64
该运动员已到达起跑线,准备好了:Thread-76
该运动员已到达起跑线,准备好了:Thread-63
该运动员已到达起跑线,准备好了:Thread-20
该运动员已到达起跑线,准备好了:Thread-35
该运动员已到达起跑线,准备好了:Thread-29
该运动员已到达起跑线,准备好了:Thread-82
该运动员已到达起跑线,准备好了:Thread-45
该运动员已到达起跑线,准备好了:Thread-55
该运动员已到达起跑线,准备好了:Thread-66
该运动员已到达起跑线,准备好了:Thread-72
该运动员已到达起跑线,准备好了:Thread-12
该运动员已到达起跑线,准备好了:Thread-88
该运动员已到达起跑线,准备好了:Thread-51
该运动员已到达起跑线,准备好了:Thread-16
该运动员已到达起跑线,准备好了:Thread-60
该运动员已到达起跑线,准备好了:Thread-8
该运动员已到达起跑线,准备好了:Thread-85
该运动员已到达起跑线,准备好了:Thread-73
该运动员已到达起跑线,准备好了:Thread-59
该运动员已到达起跑线,准备好了:Thread-50
该运动员已到达起跑线,准备好了:Thread-56
该运动员已到达起跑线,准备好了:Thread-67
所有运动员已经准备好了，裁判扣动扳机
从起跑线出发了Thread-2
从起跑线出发了Thread-6
从起跑线出发了Thread-38
从起跑线出发了Thread-23
从起跑线出发了Thread-44
从起跑线出发了Thread-75
从起跑线出发了Thread-22
该运动员已到达终点,等待裁判通知报告成绩:Thread-22
从起跑线出发了Thread-4
从起跑线出发了Thread-68
从起跑线出发了Thread-30
从起跑线出发了Thread-43
从起跑线出发了Thread-52
从起跑线出发了Thread-15
从起跑线出发了Thread-87
从起跑线出发了Thread-53
从起跑线出发了Thread-40
从起跑线出发了Thread-81
从起跑线出发了Thread-47
从起跑线出发了Thread-39
从起跑线出发了Thread-19
从起跑线出发了Thread-11
从起跑线出发了Thread-18
从起跑线出发了Thread-69
从起跑线出发了Thread-27
从起跑线出发了Thread-32
从起跑线出发了Thread-46
从起跑线出发了Thread-97
从起跑线出发了Thread-24
从起跑线出发了Thread-41
从起跑线出发了Thread-70
从起跑线出发了Thread-49
从起跑线出发了Thread-91
从起跑线出发了Thread-78
从起跑线出发了Thread-65
从起跑线出发了Thread-21
从起跑线出发了Thread-36
从起跑线出发了Thread-84
从起跑线出发了Thread-54
从起跑线出发了Thread-28
从起跑线出发了Thread-77
从起跑线出发了Thread-96
从起跑线出发了Thread-89
从起跑线出发了Thread-3
从起跑线出发了Thread-14
从起跑线出发了Thread-98
从起跑线出发了Thread-94
从起跑线出发了Thread-26
从起跑线出发了Thread-58
从起跑线出发了Thread-99
从起跑线出发了Thread-86
从起跑线出发了Thread-62
从起跑线出发了Thread-0
从起跑线出发了Thread-80
从起跑线出发了Thread-71
从起跑线出发了Thread-83
从起跑线出发了Thread-48
从起跑线出发了Thread-31
从起跑线出发了Thread-1
从起跑线出发了Thread-9
从起跑线出发了Thread-79
从起跑线出发了Thread-37
从起跑线出发了Thread-92
从起跑线出发了Thread-61
从起跑线出发了Thread-5
从起跑线出发了Thread-57
从起跑线出发了Thread-25
从起跑线出发了Thread-17
从起跑线出发了Thread-13
从起跑线出发了Thread-93
从起跑线出发了Thread-33
从起跑线出发了Thread-95
从起跑线出发了Thread-64
从起跑线出发了Thread-20
从起跑线出发了Thread-29
从起跑线出发了Thread-7
从起跑线出发了Thread-55
从起跑线出发了Thread-45
从起跑线出发了Thread-82
从起跑线出发了Thread-8
从起跑线出发了Thread-35
从起跑线出发了Thread-59
从起跑线出发了Thread-63
从起跑线出发了Thread-76
从起跑线出发了Thread-42
从起跑线出发了Thread-10
从起跑线出发了Thread-74
从起跑线出发了Thread-90
从起跑线出发了Thread-34
该运动员已到达终点,等待裁判通知报告成绩:Thread-6
从起跑线出发了Thread-56
从起跑线出发了Thread-50
从起跑线出发了Thread-73
从起跑线出发了Thread-85
从起跑线出发了Thread-60
从起跑线出发了Thread-16
该运动员已到达终点,等待裁判通知报告成绩:Thread-59
从起跑线出发了Thread-51
从起跑线出发了Thread-88
从起跑线出发了Thread-12
从起跑线出发了Thread-72
从起跑线出发了Thread-66
从起跑线出发了Thread-67
该运动员已到达终点,等待裁判通知报告成绩:Thread-18
该运动员已到达终点,等待裁判通知报告成绩:Thread-4
该运动员已到达终点,等待裁判通知报告成绩:Thread-85
该运动员已到达终点,等待裁判通知报告成绩:Thread-69
该运动员已到达终点,等待裁判通知报告成绩:Thread-82
该运动员已到达终点,等待裁判通知报告成绩:Thread-16
该运动员已到达终点,等待裁判通知报告成绩:Thread-19
该运动员已到达终点,等待裁判通知报告成绩:Thread-88
该运动员已到达终点,等待裁判通知报告成绩:Thread-37
该运动员已到达终点,等待裁判通知报告成绩:Thread-2
该运动员已到达终点,等待裁判通知报告成绩:Thread-38
该运动员已到达终点,等待裁判通知报告成绩:Thread-41
该运动员已到达终点,等待裁判通知报告成绩:Thread-8
该运动员已到达终点,等待裁判通知报告成绩:Thread-56
该运动员已到达终点,等待裁判通知报告成绩:Thread-23
该运动员已到达终点,等待裁判通知报告成绩:Thread-87
该运动员已到达终点,等待裁判通知报告成绩:Thread-53
该运动员已到达终点,等待裁判通知报告成绩:Thread-25
该运动员已到达终点,等待裁判通知报告成绩:Thread-94
该运动员已到达终点,等待裁判通知报告成绩:Thread-17
该运动员已到达终点,等待裁判通知报告成绩:Thread-92
该运动员已到达终点,等待裁判通知报告成绩:Thread-11
该运动员已到达终点,等待裁判通知报告成绩:Thread-76
该运动员已到达终点,等待裁判通知报告成绩:Thread-44
该运动员已到达终点,等待裁判通知报告成绩:Thread-95
该运动员已到达终点,等待裁判通知报告成绩:Thread-31
该运动员已到达终点,等待裁判通知报告成绩:Thread-52
该运动员已到达终点,等待裁判通知报告成绩:Thread-1
该运动员已到达终点,等待裁判通知报告成绩:Thread-64
该运动员已到达终点,等待裁判通知报告成绩:Thread-62
该运动员已到达终点,等待裁判通知报告成绩:Thread-12
该运动员已到达终点,等待裁判通知报告成绩:Thread-13
该运动员已到达终点,等待裁判通知报告成绩:Thread-7
该运动员已到达终点,等待裁判通知报告成绩:Thread-36
该运动员已到达终点,等待裁判通知报告成绩:Thread-90
该运动员已到达终点,等待裁判通知报告成绩:Thread-14
该运动员已到达终点,等待裁判通知报告成绩:Thread-67
该运动员已到达终点,等待裁判通知报告成绩:Thread-89
该运动员已到达终点,等待裁判通知报告成绩:Thread-81
该运动员已到达终点,等待裁判通知报告成绩:Thread-34
该运动员已到达终点,等待裁判通知报告成绩:Thread-57
该运动员已到达终点,等待裁判通知报告成绩:Thread-21
该运动员已到达终点,等待裁判通知报告成绩:Thread-3
该运动员已到达终点,等待裁判通知报告成绩:Thread-71
该运动员已到达终点,等待裁判通知报告成绩:Thread-96
该运动员已到达终点,等待裁判通知报告成绩:Thread-60
该运动员已到达终点,等待裁判通知报告成绩:Thread-46
该运动员已到达终点,等待裁判通知报告成绩:Thread-65
该运动员已到达终点,等待裁判通知报告成绩:Thread-99
该运动员已到达终点,等待裁判通知报告成绩:Thread-51
该运动员已到达终点,等待裁判通知报告成绩:Thread-50
该运动员已到达终点,等待裁判通知报告成绩:Thread-75
该运动员已到达终点,等待裁判通知报告成绩:Thread-61
该运动员已到达终点,等待裁判通知报告成绩:Thread-84
该运动员已到达终点,等待裁判通知报告成绩:Thread-86
该运动员已到达终点,等待裁判通知报告成绩:Thread-30
该运动员已到达终点,等待裁判通知报告成绩:Thread-98
该运动员已到达终点,等待裁判通知报告成绩:Thread-80
该运动员已到达终点,等待裁判通知报告成绩:Thread-48
该运动员已到达终点,等待裁判通知报告成绩:Thread-20
该运动员已到达终点,等待裁判通知报告成绩:Thread-93
该运动员已到达终点,等待裁判通知报告成绩:Thread-97
该运动员已到达终点,等待裁判通知报告成绩:Thread-43
该运动员已到达终点,等待裁判通知报告成绩:Thread-42
该运动员已到达终点,等待裁判通知报告成绩:Thread-63
该运动员已到达终点,等待裁判通知报告成绩:Thread-32
该运动员已到达终点,等待裁判通知报告成绩:Thread-35
该运动员已到达终点,等待裁判通知报告成绩:Thread-29
该运动员已到达终点,等待裁判通知报告成绩:Thread-24
该运动员已到达终点,等待裁判通知报告成绩:Thread-15
该运动员已到达终点,等待裁判通知报告成绩:Thread-91
该运动员已到达终点,等待裁判通知报告成绩:Thread-33
该运动员已到达终点,等待裁判通知报告成绩:Thread-79
该运动员已到达终点,等待裁判通知报告成绩:Thread-28
该运动员已到达终点,等待裁判通知报告成绩:Thread-26
该运动员已到达终点,等待裁判通知报告成绩:Thread-83
该运动员已到达终点,等待裁判通知报告成绩:Thread-58
该运动员已到达终点,等待裁判通知报告成绩:Thread-66
该运动员已到达终点,等待裁判通知报告成绩:Thread-77
该运动员已到达终点,等待裁判通知报告成绩:Thread-47
该运动员已到达终点,等待裁判通知报告成绩:Thread-74
该运动员已到达终点,等待裁判通知报告成绩:Thread-70
该运动员已到达终点,等待裁判通知报告成绩:Thread-78
该运动员已到达终点,等待裁判通知报告成绩:Thread-73
该运动员已到达终点,等待裁判通知报告成绩:Thread-54
该运动员已到达终点,等待裁判通知报告成绩:Thread-5
该运动员已到达终点,等待裁判通知报告成绩:Thread-72
该运动员已到达终点,等待裁判通知报告成绩:Thread-0
该运动员已到达终点,等待裁判通知报告成绩:Thread-10
该运动员已到达终点,等待裁判通知报告成绩:Thread-49
该运动员已到达终点,等待裁判通知报告成绩:Thread-45
该运动员已到达终点,等待裁判通知报告成绩:Thread-40
该运动员已到达终点,等待裁判通知报告成绩:Thread-39
该运动员已到达终点,等待裁判通知报告成绩:Thread-68
该运动员已到达终点,等待裁判通知报告成绩:Thread-27
该运动员已到达终点,等待裁判通知报告成绩:Thread-55
该运动员已到达终点,等待裁判通知报告成绩:Thread-9
~~~~~裁判员等待所有运动员~都已经跑完了~~~~~~~
报告自己成绩Thread-22
报告自己成绩Thread-6
报告自己成绩Thread-59
报告自己成绩Thread-18
报告自己成绩Thread-4
报告自己成绩Thread-85
报告自己成绩Thread-82
报告自己成绩Thread-88
报告自己成绩Thread-69
报告自己成绩Thread-38
报告自己成绩Thread-41
报告自己成绩Thread-2
报告自己成绩Thread-37
报告自己成绩Thread-53
报告自己成绩Thread-19
报告自己成绩Thread-17
报告自己成绩Thread-16
报告自己成绩Thread-44
报告自己成绩Thread-52
报告自己成绩Thread-76
报告自己成绩Thread-11
报告自己成绩Thread-92
报告自己成绩Thread-1
报告自己成绩Thread-64
报告自己成绩Thread-94
报告自己成绩Thread-62
报告自己成绩Thread-25
报告自己成绩Thread-12
报告自己成绩Thread-87
报告自己成绩Thread-7
报告自己成绩Thread-90
报告自己成绩Thread-23
报告自己成绩Thread-56
报告自己成绩Thread-8
报告自己成绩Thread-81
报告自己成绩Thread-89
报告自己成绩Thread-67
报告自己成绩Thread-21
报告自己成绩Thread-71
报告自己成绩Thread-60
报告自己成绩Thread-14
报告自己成绩Thread-65
报告自己成绩Thread-51
报告自己成绩Thread-50
报告自己成绩Thread-75
报告自己成绩Thread-84
报告自己成绩Thread-98
报告自己成绩Thread-36
报告自己成绩Thread-13
报告自己成绩Thread-20
报告自己成绩Thread-31
报告自己成绩Thread-93
报告自己成绩Thread-95
报告自己成绩Thread-48
报告自己成绩Thread-97
报告自己成绩Thread-80
报告自己成绩Thread-42
报告自己成绩Thread-30
报告自己成绩Thread-86
报告自己成绩Thread-91
报告自己成绩Thread-61
报告自己成绩Thread-99
报告自己成绩Thread-33
报告自己成绩Thread-79
报告自己成绩Thread-46
报告自己成绩Thread-28
报告自己成绩Thread-26
报告自己成绩Thread-96
报告自己成绩Thread-3
报告自己成绩Thread-57
报告自己成绩Thread-34
报告自己成绩Thread-77
报告自己成绩Thread-47
报告自己成绩Thread-66
报告自己成绩Thread-58
报告自己成绩Thread-70
报告自己成绩Thread-54
报告自己成绩Thread-5
报告自己成绩Thread-83
报告自己成绩Thread-15
报告自己成绩Thread-0
报告自己成绩Thread-10
报告自己成绩Thread-45
报告自己成绩Thread-40
报告自己成绩Thread-39
报告自己成绩Thread-24
报告自己成绩Thread-68
报告自己成绩Thread-55
报告自己成绩Thread-29
报告自己成绩Thread-35
报告自己成绩Thread-32
报告自己成绩Thread-63
报告自己成绩Thread-43
报告自己成绩Thread-9
报告自己成绩Thread-27
报告自己成绩Thread-49
报告自己成绩Thread-72
报告自己成绩Thread-73
报告自己成绩Thread-78
报告自己成绩Thread-74



