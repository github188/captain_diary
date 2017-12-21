
这种搞法太粗犷了，每次都新建一个线程，太浪费了，迟早会崩掉的。 看ThreadB1

``` java
public class ThreadB {
	static int i = 1;
	public static void main(String[] args) {
		while(true) {
		 new Thread(new Runnable() {
			@Override
			public void run() {
				synchronized (ThreadA.class) {
					if(i<=0) {
						try {
							Thread.currentThread();
							Thread.sleep(200);
						} catch (InterruptedException e) {
							e.printStackTrace();
						}
						System.out.println("生产者："+(++i));
					}
				}
			}
		}).start();
		 new Thread(new Runnable() {
				@Override
				public void run() {
					synchronized (ThreadA.class) {
						if(i>=1) {
							try {
								Thread.currentThread();
								Thread.sleep(200);
							} catch (InterruptedException e) {
								e.printStackTrace();
							}
							System.out.println("消费者："+(--i));
						}
					}
				}
			}).start();
		}
	}
}
```
