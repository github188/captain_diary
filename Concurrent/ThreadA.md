``` java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
public class ThreadA {
	static int i = 1;
	public static void main(String[] args) {
		fixedThreadPool();
		singleThreadPool();
		cachedThreadPool();
	}
	public static void fixedThreadPool() {
		ExecutorService es = Executors.newFixedThreadPool(3);
		for (int i = 1; i <= 10; i++) {
			final int task = i ;
			es.execute(new Runnable() {
				@Override
				public void run() {
					for (int j = 1; j <= 5; j++) { //假设j代表绕操场跑几圈
						System.out.println(Thread.currentThread().getName()+"目前正在跑第"+task+"个任务中的第"+j+"圈");
					}
				}
			});
		}
	}
	public static void singleThreadPool() {
		ExecutorService es = Executors.newSingleThreadExecutor();
		for (int i = 1; i <= 10; i++) {
			final int task = i ;
			es.execute(new Runnable() {
				@Override
				public void run() {
					for (int j = 1; j <= 5; j++) { //假设j代表绕操场跑几圈
						System.out.println(Thread.currentThread().getName()+"目前正在跑第"+task+"个任务中的第"+j+"圈");
					}
				}
			});
		}
	}
	public static void cachedThreadPool() {
		ExecutorService es = Executors.newCachedThreadPool();
		for (int i = 1; i <= 10; i++) {
			final int task = i ;
			es.execute(new Runnable() {
				@Override
				public void run() {
					for (int j = 1; j <= 5; j++) { //假设j代表绕操场跑几圈
						System.out.println(Thread.currentThread().getName()+"目前正在跑第"+task+"个任务中的第"+j+"圈");
					}
				}
			});
		}
	}
}


```
