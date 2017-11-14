可以用nginx来做转发/重定向   胡宇恒 韩伟东都实践过

可以用公网的IP 映射到本地的很多端口上

>server {
        listen       9090;
        server_name  127.0.0.1;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
       root   html;
       index  index.html index.htm;
    }
    #Proxy Settings
        location /mswcf {
             rewrite    ^.+mswcf/?(.*)$ /$1 break;
             proxy_pass http://172.16.58.39:8080/;
    }
        location /uswcf {
             rewrite    ^.+uswcf/?(.*)$ /$1 break;
             proxy_pass http://172.16.58.38:8080/;
    }
        location /cswcfw {
             rewrite    ^.+cswcfw/?(.*)$ /$1 break;
             proxy_pass http://172.16.58.37/;
    }    
        #error_page  404              /404.html;
}
