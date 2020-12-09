---
layout: single
title: "An Introduction to Multithreading"
date: 2020-03-25 09:00:00 -0000
categories: concurrency ruby introductory
excerpt: An introduction to the idea of multithreading. First we will talk about reasons for concurrency, then we will give examples.
---



A program is ‘multithreading’ or ‘running concurrently’ when it is _doing multiple things at once_. In a basic program, you will step through one operation at a time. We all have learned basic looping over an array. But what if our program could run two instances at once, each over half the array? If each instance was as fast as the original, they could cover the array together, and in half the time.

A basic looping function in Ruby:

```ruby
def get_sum_of_two_arrays(a1, a2)
  sum_a1 = 0
  a1.each {|e1| sum_a1 += e1}

  sum_a2 = 0
  a2.each {|e2| sum_a2 += e2}
  return sum_a1 + sum_a2
end
```

But how would this happen with two concurrent threads? Let’s spitball something:

```ruby
def get_sum_of_two_arrays_with_threads(a1, a2)
  # Will skip from one line to next immediately after passing arguments
  # Does not need a return value immediately
  Thread(get_sum_of_one_array(a1))
  Thread(get_sum_of_one_array(a2)
end
```

But hold on! That was not necessary, nor was it a good example. Why would we bother doing that for such a small thing? In fact, few _simple_ programmatical examples need multithreading. Multithreading is most interesting, and most useful, in _complex scenarios_. Many introductions to threads use concurrency in unnecessary situations. I dislike this approach. Let’s try to build something that is simple, but still shows the usefulness of multithreading.

# The Thought Process

Consider an online game. In a game, there are several things happening at once:
  - The game is being rendered
  - You are sending data to the server (your actions in-game)
  - You are receiving from the server (other people's actions in-game)

| ![An example of an online game](/assets/images/blogs/multithreading_image.jpeg "An online game") |
|:--:|
| *Even if you lose connection, you should still be able to fish* |


In this example, we _need_ to do multiple things at once. We can't just run a linear block:
```ruby
while true 
  render_game()
  receive_data() # have to wait for this?
  send_data()
end
```
Networks are unreliable, and your data from the server will not come in nice, clean increments. The server may send the first packet after 5ms, but then you may lose connection for 1000ms. The player avatar should not freeze in place while you are waiting for data. The game should continue to run in the meantime, then correct things after the lag. We _could_ consider something like this:
```ruby
while true 
  render_game()
  if receive_data() # just wait for a few ms and try to receive some data
    # do something with the received data
  end
  send_data()
end
```
But we will still have to wait on the receive_data function. It will be difficult to predict how long the transmission takes. How long should we wait?

If we listen for server data on _another thread_, we can run the tasks independently. The only question is how to get them to communicate. Let's try some pseudocode:
```ruby
$game_data = {GAME_DEFAULT}

tell_some_thread(wait_for_incoming_data)
  then, when it has the data:
    $game_data = incoming_data

while true
  render_game($game_data)
  send_data(whatever_the_player_is_doing)
end
```
Note how our two threads communicate through `$game_data`. Now if the server or network has some hiccups, so be it! The game will continue to run, and just experience some lag (hopefully for no longer than a few ms). Player experience will be less interrupted.

At the end of this, I will go through an example of multithreading in Ruby. However, I believe that the important aspect is to understand the larger picture. With that in mind, let’s consider some potential problems that can arise. 

# Common problems

Problems with concurrency can be complex and difficult to debug. Due to multiple sources of modification, you can experience unintuitive issues.
  - _Security Issues_: bad design patterns may lead to a variable being accessible at a high level, which in turn makes it more vulnerable
  - _Visibility Issues_: a thread reads shared data before it is changed, but is unaware of the update
  - _Access Issue/Race Conditions_: occurs when multiple threads attempt to change a shared value at one time. This is one of the biggest concerns with multithreading, and its fixes _provide their own issues_, such as deadlocks and inefficient locking methods.

# Ruby example
This example prints a pattern, but accommodates outside changes. It prints linearly increasing values, but changes depending on user input.
```ruby
$delta = 5

def pattern
  i = 0
  while true
     puts i
     i = i + $delta
     sleep(3)
  end
end

def change_delta
  while true
    i = gets.chomp.to_i
    $delta = i
    puts "Changed delta to: #{i}"
    end
  end

t1 = Thread.new{pattern()}
t2 = Thread.new{change_delta()}

t1.join()
t2.join()
```

Note that our example is still a bit dangerous. We are using a global variable to communicate, which is not recommended.

The ruby docs has an [even more simple example](https://www.tutorialspoint.com/ruby/ruby_multithreading.htm). I use ours to illustrate how different threads can communicate.

# Sources

[ruby multithreading docs](https://www.tutorialspoint.com/ruby/ruby_multithreading.htm)

[wikipedia](https://en.wikipedia.org/wiki/Thread_(computing)#Multithreading)

[OWASP](https://www.owasp.org/images/blogs/8/8e/OWASP_NZDay_2011_BrettMoore_ConcurrencyVulnerabilities.pdf)

[vogella](https://www.vogella.com/tutorials/JavaConcurrency/article.html#concurrency-issues)

[good ol' StackOverflow](https://stackoverflow.com/questions/34510/what-is-a-race-condition)

If you liked the post, I would appreciate it if you gave it some claps on [Medium](https://medium.com/@eking_30347/an-introduction-to-multithreading-72d57d075ef1){:target="_blank"}