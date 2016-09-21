select t2.username,max(t2.age) from user t2 group by t2.username ;
select 
    *
from
    user;
insert user values (3,'a','admin',1,3,'huangleisir@qq.com',1,curdate());
insert user values (4,'a','admin',1,4,'huangleisir@qq.com',1,curdate());
insert user values (5,'a','admin',1,5,'huangleisir@qq.com',1,curdate());
insert user values (6,'a','admin',1,6,'huangleisir@qq.com',1,curdate());
insert user values (7,'a','admin',1,7,'huangleisir@qq.com',1,curdate());
insert user values (8,'b','admin',1,8,'huangleisir@qq.com',1,curdate());
insert user values (9,'b','admin',1,1,'huangleisir@qq.com',1,curdate());
insert user values (10,'b','admin',1,2,'huangleisir@qq.com',1,curdate());
insert user values (11,'b','admin',1,3,'huangleisir@qq.com',1,curdate());
insert user values (12,'c','admin',1,4,'huangleisir@qq.com',1,curdate());
insert user values (13,'d','admin',1,1,'huangleisir@qq.com',1,curdate());
insert user values (14,'d','admin',1,2,'huangleisir@qq.com',1,curdate());
insert user values (15,'d','admin',1,3,'huangleisir@qq.com',1,curdate());
insert user values (16,'e','admin',1,4,'huangleisir@qq.com',1,curdate());
insert user values (17,'e','admin',1,5,'huangleisir@qq.com',1,curdate());
insert user values (18,'e','admin',1,6,'huangleisir@qq.com',1,curdate());
insert user values (19,'e','admin',1,7,'huangleisir@qq.com',1,curdate());
update user 
set 
    password = 'admin'
where
    username = 'admin';
select 
    *
from
    user;

delete t1 from user t1 , 
(select t2.username username,max(t2.age) maxage
from user t2 group by t2.username   )  t3
where t1.age < t3.maxage and t1.username=t3.username;
rollback;