---
layout: single
title: "Navigating an Unfamiliar Codebase (with Github & VSCode)"
date: 2020-10-14 09:00:00 -0000
categories: vscode tips git github
---

As a follow-up for my [previous post]({% post_url 2020-04-14-vscode %}), I thought I would look at VSCode from a more intermediate level. Specifically, getting into a larger codebase. Once you get a job, or join an open-source project, you will be thrown head-first into a large codebase. Whether or not you get an introduction, it is good to know how to dive in.

# Visual Studio Tricks

Presumably you will start with a simple task. You will be given a file, and be told to change it. However, you may not know how to find everything that interconnects with the file!

`cmd-shift-f`: search all files. This can be useful for a number of reasons:

__Find where a library is imported__: perhaps you know that the app is generating graphs, but you can't find where the origin of the graphs is. If you know the library being used, you can search for the files that import it.

__Find where constants are declared__: this is useful when a site is large and complex. This is especially relevant if the constant is some text like "Frequently Asked Questions," which will never have overlap with a program variable name. Often, a constant will be declared in a text or json file. This also connects with our next possibility:

__Sometimes things are created by a framework__, and are hard to find. For example, Rails will have a built-in connection between routes and controllers, but the `routes.rb` will not explicitly import the controllers. If there is a lot of work being done behind the scenes, this can be useful to connect things together.

{% include image.html url="/assets/images/navigating_codebase/search_twitter.png" description="Trying to find the social.twitter source" %}

`cmd-p`: jump to file. 

I have spoken about this before, and I will again. This is an incredibly useful command. Additionally, if you don't know the filename, but _do_ know the directory, this will also open files by their directory name!

|![Searching for the right router](/assets/images/navigating_codebase/open_file.png)|
|_Now that we have all the router files, we can narrow down which one we want_|

`method hover`: when a method is called by the file you are in, you can hover over it with your mouse. If you have the extension for your language, this will show the method arguments and docstring. Additionally, you can `cmd-click` it to jump to the method definition (and the file containing it).

|![Javascript substring documentation on hover](/assets/images/navigating_codebase/method_overview.png)|
|_Javascript substring documentation on hover_|

`debugging`: I will only briefly talk about this, because it is different for each language. However, after trying it I will guarantee it will change your life. Logging every line gets old, and is very inflexible. Most debuggers will stop at a certain line, and then you can view the value of all variables at that point. I strongly encourage you to try it out.

# Git/hub Tricks

With git & Github, the most useful things to look at are old commits. Ideally, you want to find code (in your current repository) that is similar to what you are about to work on, then [__plagiarize__](https://www.youtube.com/watch?v=gXlfXirQF3A). Steal as much as you can, and change as little as possible so that it works with your new functionality. You can look through existing files, but you may want to narrow it down within a file:

`history`: If you look at the first commit of a file, this will be its simplest form. Everything after will (probably) just be added complexity. This commit is also useful, because it may show other changes necessary when the file was first created. For example, if a new route was needed, this commit may include that.

`blame`: this clumps lines together that were in the same commit. If you are looking for specific logic, this may show other relevant lines.

|![Protobuf code blame](/assets/images/navigating_codebase/code_blame.png)|
|_An example of blame in Google's Protobuf code base_|

# Some Thoughts

Make sure to try and iterate quickly. Don't try to build out all functionality needed at once. Just make a minimal change that sets you on the right path. Try to quickly iterate and quickly fail. Start by making a copy of an existing feature, and implement it in a similar location.