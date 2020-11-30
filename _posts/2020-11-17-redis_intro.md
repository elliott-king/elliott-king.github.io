---
layout: single
title: "An Introduction to Redis for the Junior Developer"
date: 2020-11-17 09:00:00 -0000
categories: redis javascript ruby nosql docker
---

You may have heard of [Redis](https://redis.io/). 

| <img src="/assets/images/redis/redis-logo.png" alt="Redis Logo" width="49%" > <img src="/assets/images/redis/redis-server.png" alt="Redis Server" width="49%" > |
| *Not sure that ASCII art really works* |

It is described as an "in-memory data structure store, used as a database, cache and message broker." Basically, you can think of Redis as a database. Unlike fancier databases, Redis' claim to fame is its simplicity. It isn't good at relational data or complex data structures, but it is blisteringly efficient and atomic. Fortunately, it is also simple to use.

It can be difficult to determine where to begin with Redis. If you go to the [website](https://redis.io/download), it tells you to download a tarfile. It doesn't say anything about package managers (like brew or apt), and it is unclear how to start. I wrote this guide with the junior developer in mind. I will talk about how to direct your learning, and give a brief overview:
1. Downloading Redis
2. Trying it out on the command line
3. Using it in your backend code
4. Why it is useful

## Downloading Redis

You can skip the tarball on the website, and download it with a package manager:

__Mac__: `brew install redis`. To have it run whenever your computer boots, call `brew services start redis`.

__Ubuntu__: `sudo apt-get install redis-server`. To have it run whenever your computer boots, call `sudo systemctl enable redis-server.service`.

__Windows__: may God have mercy on your soul. Try [this](https://divyanshushekhar.com/how-to-install-redis-on-windows-10/), or you can also try it with WSL ([Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)).

After this, `redis-server` should already be running (although you can manually run it with `redis-server`). You can test it by typing `redis-cli ping`, to which the output should be `PONG`. Redis runs on port 6379.

## Trying it on the Command Line

We will run Redis on the command line to give you a bit of background on the tool. Open the command line with `redis-cli`.

Create a value with `SET <key> <value>`: 

```
127.0.0.1:6379> SET name Elliott
OK
```

As you type, it will show you the inputs to whatever you are typing.
You can retrieve a value with `GET <key>`:

```
127.0.0.1:6379> GET name
"Elliott"
127.0.0.1:6379> GET dne
(nil)
```

You can check existence with `EXISTS <key>`:

```
127.0.0.1:6379> EXISTS name
(integer) 1
127.0.0.1:6379> EXISTS dne
(integer) 0
```

You can print out all keys with `KEYS *`.

Finally, you can delete a key with `DEL <key>`:

```
127.0.0.1:6379> DEL name
(integer) 1
127.0.0.1:6379> DEL dne
(integer) 0
```

You can quit with `quit`.

Redis deals almost exclusively with string values. It might be worth glancing at the [data types intro](https://redis.io/topics/data-types-intro). There are a large number of commands you can learn, but I recommend just taking a look at the [string commands](https://redis.io/commands#string) for starters. Some interesting highlights:
- You can set expiration times on keys
- You can use the `Keys` command with patterns to filter 
- You can increment/decrement numbers

## Using on the Backend

If you have not used a database before (or have only used sqlite), you may need to familiarize yourself with the idea of _running your database and program separately_. Like PostgreSQL or MongoDB, Redis is run separately. Before you install a library for your programming language, make sure `redis-server` is running.

Next, you want to download the appropriate library to interface with it. I didn't find the [client list](https://redis.io/clients) very clear, so you may want to just Google `<language> redis`.

For example, the NodeJS client is called "Redis" in the [npm package manager](https://www.npmjs.com/package/redis), but [the repository](https://github.com/NodeRedis/node-redis) is called "node-redis." The Redis client list has multiple suggestions for NodeJS.

As an example, I will use the NodeJS and Ruby clients, but most of them are well documented. 

For NodeJS, you first initiate a connection between your app and Redis:

```javascript
const redis = require('redis');
const redisClient = redis.createClient();
```

The functions are similar to what you used on the CLI, except they are asynchronous:

```javascript
client.set("key", "value", console.log);
client.get("key", console.log);
```

You must pass a callback function to handle the asynchronous response. Alternatively with NodeJS, you can use the `promisify` utility to turn them into promises:

```javascript
const redis = require('redis');
const { promisify } = require("util");

const redisClient = redis.createClient()
const redisGet = promisify(redisClient.get).bind(redisClient);
const redisSetEx = promisify(redisClient.setex).bind(redisClient);

redisGet.then(console.log).catch(console.error);
```

For Ruby, the Redis calls are not asynchronous, which matches Ruby's style better:

```Ruby
require "redis"
redis = Redis.new

redis.set("mykey", "hello world")
# => "OK"

redis.get("mykey")
# => "hello world"
```

In production, you will often want Redis running on a different server. This will make your client connections more complicated. For example, on a simple Docker setup, you might have `docker-compose` set up a container just for Redis:

```yaml
services:
  backend: 
    ...
  
  redis:
    image: 'redis:6'
    ports:
    - '6379'
```

In which case, your client connection in NodeJS might look like this:

```javascript
const redisClient = redis.createClient('redis://redis');
```

## Advantages of Redis

Like any database, it persists even while your application is down or rebooting.

The main advantage of Redis is efficiency. Because its datatypes are so simple, it can hold a great deal of information efficiently, and can process it quickly. If you want to store your most commonly accessed items in memory, Redis serves as an excellent cache. It also has built-in support for [LRU (least-recently used) caching](https://redis.io/topics/lru-cache).

Here are some [common use cases](http://highscalability.com/blog/2011/7/6/11-common-web-use-cases-solved-in-redis.html), if you need some ideas.
