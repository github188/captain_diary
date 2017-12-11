添加依赖  
<dependency>
		<groupId>com.taobao</groupId>
		<artifactId>stresstester</artifactId>
		<version>1.0</version>
	</dependency>
	
![image22222222222222222](https://github.com/huangleisir/common-pics/blob/master/D1FAOLIY1_~O~A2_%7B%7D~X7~7.png)
  如果你引入的图片有问题 中括号里面的文字下面是不会有下划线的 
  
>package com.jst.prodution.member.service;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import com.jst.prodution.member.serviceBean.LoginBean;
import com.taobao.stresstester.StressTestUtils;
import com.taobao.stresstester.core.StressResult;
import com.taobao.stresstester.core.StressTask;
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestLogin {
	@Autowired
	LoginService loginService;
	 @Test
	    public void testCache() throws Exception {
		     StressResult result = StressTestUtils.test(100, 10000, new StressTask(){
				@Override
				public Object doTask() throws Exception {
					LoginBean loginBean = new LoginBean();
					/*loginBean.setMobile("13875280990");
					loginBean.setPassword("56f448fc67bfde7dbdf7ef41dd5b4a84");*/
					loginBean.setMobile("13018690900");
					loginBean.setPassword("e9f5c5240c0bb39488e6dbfbdb1517e0");
					loginBean.setAppId("1645285811190497298");
					loginBean.setUserType("C");
					loginService.action(loginBean);
					return null;
				}
		    }
		    		,1);
		     System.out.println(StressTestUtils.format(result));
	   }
}

