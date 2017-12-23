1.
yum install mysql-server -y
2.
service mysqld restart
3.
/usr/bin/mysqladmin -u root password '123456'
4.
mysql -uroot -p123
5. 设置Mysql开机启动 
chkconfig mysqld on
6.设置该用户及密码可以从任何服务器连接mysql服务器的任何实例
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
FLUSH   PRIVILEGES;
-------OK了，可以从sql yog登录进来了--------------






















