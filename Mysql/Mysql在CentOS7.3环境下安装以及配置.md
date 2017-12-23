1.
yum install mysql-server -y
(如果不成功，则换用以下办法)
CentOS 7的yum源中貌似没有正常安装MySQL时的mysql-sever文件，需要去官网上下载
 #wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
#rpm -ivh mysql-community-release-el7-5.noarch.rpm
 #yum install mysql-community-server
2.
service mysqld restart   
3. 设置Mysql开机启动 
chkconfig mysqld on
4.
/usr/bin/mysqladmin -u root password '123456'
5.
mysql -uroot -p123456
登录之后才能执行grant语句
6.设置该用户及密码可以从任何服务器连接mysql服务器的任何实例
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
FLUSH PRIVILEGES;
-------OK了，可以从sql yog登录进来了--------------

------配置master数据库--------
vim /etc/my.cnf
在[mysqld]节点下加入两句话
>server-id=1

>log-bin=mysql-bin       #启用二进制日志

重启服务：service mysql restart 
登录mysql：mysql -uroot -p123456 
mysql>flush tables with read lock; #数据库锁表，不让写数据 
mysql>show master status; #查看MASTER状态（这两个值File和Position） 

从库启动好后，记得要解除主库锁定
mysql>unlock tables;

（http://blog.csdn.net/shootyou/article/details/6026735）

---------配置从库------------
安装方式同上

配置从服务器 
修改UUID

由于data拷贝是全目录拷贝，将/var/lib/mysql/auto.cnf也拷贝，它里面记录了对数据库的一个uuid标识，随便产生个新的uuid，替换掉新目录中的auto.cnf中的uuid串即可。
可以用select uuid()来产生新值，手工黏贴到auto.cnf文件中。
1
2
修改/etc/my.cnf增加一行

server-id=2
1
重启服务 
service mysql restart 
通过mysql命令配置同步日志的指向：

change master to master_host='192.168.58.130',master_port=3306,master_user='root',master_password='123456',master_log_file='mysql-bin.000001',master_log_pos=120;
1
2
master_host 主服务器的IP地址 
master_port 主服务器的PORT端口 
master_log_file 和主服务器show master status中的File字段值相同 
master_log_pos 和主服务器show master status中的Position字段值相同

start slave; #stop slave;停止服务，出错时先停止，再重新配置 
show slave status\G   --注意这里结尾不要跟分号  #查看SLAVE状态，\G结果纵向显示。必须大写. 
只有出现两个yes才算成功。 
注意：如果出错，可以看后面的错误信息。观察Slave_SQL_Running_State字段，它会记录详细的错误信息。如果正常，上面两个线程执行都应该是YES。这样当主库创建数据库、创建表、插入数据时，从库都会立刻同步，这样就实现了主从复制。

这里写图片描述

service mysql restart #重启服务
如果 没有出现这个，主库运行一下unlock tables;  然后再再次启动一下 service mysql restart 
下面这个是出现在第11,12行
        Slave_IO_Running: Yes
        Slave_SQL_Running: Yes


这样就算是完成了mysql的主从配置了
在主库增加实例，建表，增删改，在从库增删改，不会同步到主库。这里可以作为一个面试题来考察。
还有双主和互为主从，也是可以这样去配置的，有时间的时候可以去研究一下。


http://blog.csdn.net/xmz_java/article/details/54896955


 













