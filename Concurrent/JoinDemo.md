
``` java
package concurrent;
public class JoinDemo implements Runnable {
	public void run() {
		for (int i = 0; i < 100; i++) {
			try {
				Thread.sleep(1);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			System.out.println("join "+i);
		}
	}
	public static void main(String[] args) throws InterruptedException {
		Thread t = new Thread(new JoinDemo());
		t.start();
		for (int i = 0; i < 100; i++) {
			if(i==50){
				t.join();
			}
			System.out.println("main "+i);
		}
	}
```
你注意这里t.join()方法的出现一定是在t线程之外的另一个线程的代码中，就是让这个线程等一等，跟join的含义有什么区别，你可以把它理解为嫁接中的结合，
而且优先级比那个线程t.join()之后的代码执行优先级还要高。这个很有意思。
让我想起来了，那年过年在曹武大幺家里吃饭，张飞几个小家伙，菜都抢光。呵呵。
