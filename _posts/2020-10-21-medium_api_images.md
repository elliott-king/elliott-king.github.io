---
layout: single
title: "Debugging Medium Images"
date: 2020-10-21 09:00:00 -0000
categories: javascript medium API debugging
---

### A Dive Into Some Odd Aspects of Medium's Platform

I always enjoy reading about large and complex problems, but sometimes it is interesting to dive into a tiny incongruity. 

I write my blogs in markdown, then post them to my [personal site]({{site.baseurl}}), then import them to Medium. I try to be as lazy as possible, so I have been working on ways to streamline the process; specifically the import to Medium. From this, I found an interesting rabbit hole: __Medium's API and import buttons will display the same HTML differently__. If I import something using the `Import` button, it will not display the same as if I upload it using the Medium API.

## Background

If you click the `Import` button, Medium actually handles blogs quite well, with some exceptions:
 - lists
 - code blocks
 - block quotes
 - images

Lists can be hit-or-miss, code blocks rarely show, quotes are weirdly formatted, and images are also hit-or-miss.

For me, the most annoying aspect was images. Quotes and lists, I rarely use. Code blocks I use occasionally. Images, however, I use all the time.

## Displaying Images

Since I write in markdown ([Jekyll](https://jekyllrb.com/) specifically), it is a bit difficult to add captions to images. When I started out, I used [a suggestion](https://stackoverflow.com/questions/19331362/using-an-image-caption-in-markdown-jekyll#30366422) to place my images in tables. In a file, that looks something like this:

```md
| ![An example of an online game](/assets/images/blogs/multithreading_image.jpeg "An online game") |
|:--:|
| *Even if you lose connection, you should still be able to fish* |
```

And on the site, it looks like this:

{% include image.html url="/assets/images/blog_on_medium/md_image_in_table.png" description="The table generated. The image is in the first cell, and the 'caption' is in the second." %}

You may notice that is not the most popular answer in the StackOverflow question linked above 🤷 It seemed easy at the time, but eventually I would come to regret it. When clicking the `Import` button in Medium, these images would usually not show up at all. This is annoying, as that means that I have to reimport each image.

### Looking at How Medium Displays Images

If you `inspect element` on an image in a Medium post, you will notice that the image is wrapped in a `<figure>`, which is an obscure HTML element I was not familiar with. Basically, you can wrap an `<img>` with it, and there is a built-in `<figcaption>` element you can use for the caption. Look at that, I already learned something new!

It is possible to add a `<figure>` element to my blog. I just have to modify some files, and can then write something like this:

```md
{% include image.html url="/assets/images/blogs/multithreading_image.jpeg" description="Even if you lose connection, you should still be able to fish" %}
```

The image looks like this:

![Image with figure on my blog site](/assets/images/blog_on_medium/md_image_with_figure_caption.png)

I think the table looked better, but I could probably fix that with some CSS.

So now, let's go to Medium and try using the `Import` button. __Unfortunately__, this still does not display properly! It does show the image, but does not include the caption. That is slightly more helpful, but not amazing.

### Trying the API

I had already been fiddling with the [Medium API](https://github.com/Medium/medium-api-docs) a bit. So, out of curiosity, I decided to try uploading through the API. The API is neither user-intuitive, well-documented, or consistently maintained, but it is very simple! It is easy to follow because it has very few use cases. You can, however, use it to upload a new post to your account (although it is a bit touchy about it). After some testing, I came up with this [mild abomination](https://gist.github.com/elliott-king/1bd37bb3a01686a083e5e815974c36b4) in Ruby. Basically, it scrapes a given URL, and then sends everything in the `<article>` tag to Medium. And voilà, it showed the caption on Medium!

{% include image.html url="/assets/images/blog_on_medium/yes_caption.png" description="Here is what the image & caption look like on Medium." %}

However, that means that the API and the `Import` button get the same HTML, and return different results! 

## In Idiosyncrasies we Trust

{% include image.html url="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia1.tenor.com%2Fimages%2F819e1a596896a3607b0f49b575b491cc%2Ftenor.gif%3Fitemid%3D8490815&f=1&nofb=1" description="Medium also imports and copies images, keeping them on their own CDN. This image may eventually 404 on my blog, but not on Medium!" %}

Software companies end up in strange places. Interestingly enough, Medium is [using a third-party service](https://help.medium.com/hc/en-us/articles/360033931713) for their `Import` button. But are they using a third-party service for their API? My guess would be no, but I am not sure.

I always find things like this very interesting. A large, profitable tech company has two features which do _almost exactly_ the same thing, but they are implemented differently! I think it just goes to show how much chaos there is in the world. It makes me optimistic, in a way.

![Life finds a way](https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fs2.quickmeme.com%2Fimg%2Fc0%2Fc0de37db2473e77c7d66f583cbf6384651fbbac94fa67d6b7a9fda6a4f4ca38b.jpg&f=1&nofb=1)

PS, if you need to hire a fullstack engineer who likes both the big and little things, [hit me up](https://www.linkedin.com/in/elliottwking/). That goes for you too, Medium.