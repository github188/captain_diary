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








 













