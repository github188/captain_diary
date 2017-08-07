linux环境下 start.sh 
nohup java -jar -Dspring.profiles.active=dev -Xms1024m -Xmx1024m -XX:PermSize=256M -XX:MaxPermSize=512m member.jar 2>&1 & 
