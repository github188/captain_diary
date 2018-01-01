 https://www.cnblogs.com/WJ5888/p/4618465.html   这篇文章讲的非常好，有空可以琢磨一下，可以在编程中装X使用
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








