
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
源码里面的注释 比较搞笑，一直要等到这个客人死亡，才能执行自己的代码，这么悲催。
/**
     * Waits for this thread to die.
     *
     跟人家抢不赢了，就找个人去人家家里去说一声，等我执行完了，你再执行。
main 0
join 0
main 1
main 2
main 3
main 4
main 5
main 6
main 7
main 8
main 9
join 1
main 10
join 2
main 11
main 12
join 3
main 13
main 14
main 15
main 16
main 17
main 18
main 19
main 20
main 21
join 4
main 22
join 5
main 23
join 6
main 24
join 7
main 25
join 8
main 26
join 9
main 27
join 10
main 28
join 11
main 29
join 12
main 30
join 13
main 31
join 14
main 32
join 15
main 33
join 16
main 34
join 17
main 35
join 18
main 36
join 19
main 37
join 20
join 21
join 22
main 38
join 23
join 24
join 25
join 26
join 27
join 28
main 39
main 40
main 41
main 42
main 43
join 29
main 44
join 30
main 45
join 31
join 32
main 46
join 33
join 34
join 35
join 36
join 37
join 38
join 39
main 47
join 40
join 41
join 42
join 43
join 44
join 45
join 46
join 47
join 48
join 49
main 48
join 50
main 49
join 51
join 52
join 53
join 54
join 55
join 56
join 57
join 58
join 59
join 60
join 61
join 62
join 63
join 64
join 65
join 66
join 67
join 68
join 69
join 70
join 71
join 72
join 73
join 74
join 75
join 76
join 77
join 78
join 79
join 80
join 81
join 82
join 83
join 84
join 85
join 86
join 87
join 88
join 89
join 90
join 91
join 92
join 93
join 94
join 95
join 96
join 97
join 98
join 99
main 50
main 51
main 52
main 53
main 54
main 55
main 56
main 57
main 58
main 59
main 60
main 61
main 62
main 63
main 64
main 65
main 66
main 67
main 68
main 69
main 70
main 71
main 72
main 73
main 74
main 75
main 76
main 77
main 78
main 79
main 80
main 81
main 82
main 83
main 84
main 85
main 86
main 87
main 88
main 89
main 90
main 91
main 92
main 93
main 94
main 95
main 96
main 97
main 98
main 99
