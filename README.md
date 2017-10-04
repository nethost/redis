# redis
Redis docker image

# Redis Docker Images

Docker + Alpine3.6 + Redis4.0.1

#### Start a redis instance
```
$ docker run --name some-redis -d nethost/redis
```

#### Start with persistent storage
```
$ docker run --name some-redis -d nethost/redis redis-server --appendonly yes
```

#### Connect to it from an application
```
$ docker run --name some-app --link some-redis:nethost/redis -d application-that-uses-redis
```

#### Your own redis.conf
```
$ FROM nethost/redis
$ COPY redis.conf /usr/local/etc/redis/redis.conf
$ CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]

or 

$ docker run -v /myredis/conf/redis.conf:/usr/local/etc/redis/redis.conf --name myredis redis redis-server /usr/local/etc/redis/redis.conf
```

## 辅助命令
```
$ docker ps -l
$ docker stop $(docker ps -a -q)
$ docker rm $(docker ps -a -q)
$ docker rmi $(docker images -q)
$ docker rmi $(docker images -q -f dangling=true)
```