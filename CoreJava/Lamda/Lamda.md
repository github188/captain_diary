 
 
 为什么lamda表达式的可读性这么差，因为它里面有一些语句推断，予以推断，自动推断。
 lamda表达式不是一个语句，而是一个匿名对象。java.util.function包可以好好看一下
 工作中有可用lamda表达式的地方，有这样的机会千万不要错过。
 http://edu.51cto.com/center/course/lesson/index?id=186735  这个课程是已经购买的
 http://www.importnew.com/16436.html  这篇文章有点意思   https://chuanke.baidu.com/3095819-137456.html 李兴华这个课程非常不错，
 必要时可以购买
 https://www.cnblogs.com/WJ5888/p/4618465.html   这篇文章讲的非常好，有空可以琢磨一下，可以在编程中装X使用，李兴华的网易公开课上降到了jdk8
 的lamda表达式。
 lamda表达式更像是一个匿名实例，作为传参来使用 
 他并不能作为一条单独的语句来执行，编译都会通不过。
 
``` java
 public static void main(String[] args) {
 
//    	() -> {System.out.println("lamda expression");};
    /*	new Thread( () -> 
    		System.out.println("In Java8, Lambda expression rocks !!")
    	).start();*/
    		new Thread(  () -> {
    			System.out.println("Hello Lambda Expressions1");
    			System.out.println("Hello Lambda Expressions2");
    			System.out.println(Thread.currentThread().getName());
    			
    		}
	).start();
    		String []datas = new String[] {"peng","zhao","li"};
    	    Arrays.sort(datas);
    	    Arrays.sort(datas,(v1 , v2) -> Integer.compare(v1.length(), v2.length()));
    	    Stream.of(datas).forEach((param) ->     System.out.println(param));
    	
//        SpringApplication.run(BookApplication.class, args);
    }
```
第一个例子 我不说了  这太简单了
``` java
// Java 8之前：
new Thread(new Runnable() {
    @Override
    public void run() {
    System.out.println("Before Java8, too much code for too little to do");
    }
}).start();
1
2
	
//Java 8方式：
new Thread( () -> System.out.println("In Java8, Lambda expression rocks !!") ).start();
```
第二个例子  






