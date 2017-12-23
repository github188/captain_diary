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
mysql -uroot -p123
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
登录mysql：mysql –uroot -proot 
mysql>flush tables with read lock; #数据库锁表，不让写数据 
mysql>show master status; #查看MASTER状态（这两个值File和Position） 

从库启动好后，记得要解除主库锁定
mysql>unlock tables;



---------配置从库------------
安装方式同上







 













