linux环境下 start.sh 
nohup java -jar -Dspring.profiles.active=dev -Xms1024m -Xmx1024m -XX:PermSize=256M -XX:MaxPermSize=512m member.jar 2>&1 & 
nohup是在后台执行该程序 以守护线程的形式  前台退出该线程  后台该线程仍然在跑
启完之后  出现这个不要犯傻 nohup: ignoring input and appending output to `nohup.out'
赶紧去 tail -f nohup.out 看启动日志就行了 


linux  切换用户   su - 新用户名 

