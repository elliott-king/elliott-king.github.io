---
layout: single
title: "Thinking About Services"
date: 2020-09-09 12:00:00 -0000
categories: architecture REST API
excerpt: Thoughts about service-based architecture.
---

|![Kitchenware](/assets/images/services/jaime-moag-oZC0wd6LANM-unsplash.jpg)|
|<span>Photo by <a href="https://unsplash.com/@jaimemoag?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Jaime Moag</a> on <a href="https://unsplash.com/s/photos/services?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span>|

I recently went through a bootcamp with Flatiron School. Since I have prior experience, I have a leg up on other students. However, my fellow students bring a valuable change in perspective. This motivated me to think about the additional exposure I have to programming concepts, and to think about next steps for bootcamp graduates. What would these look like?

My bootcamp focused purely on the concepts of full-stack development: Rails on the backend, React/JS on the frontend. We were taught the basics about data structures, but very little in the way of algorithms. We focused more on things like Model-View-Controller, SQL, and REST, all things that my CS degree did not put much thought into. I appreciated these, because I had never received a formal education in these concepts, although I had been exposed to them. 

After graduation, we are expected to continue our learning by ourselves. Some of this is self explanatory. Many of my classmates have put off their job search for a month to learn about algorithms. There are millions of articles out there about algorithms (some written by me), so I will refrain from talking about them. Instead, I would like to talk about the natural extension of API design and DRY coding methodology: **services**. I don't mean for this to be a coding guide, just something to help you understand why they are useful.

**API Design**:

Structurally, our bootcamp projects were straightforward. Our backend was Rails-as-an-API, and the frontend was Javascript, potentially with React. If we needed to store image files, we would use the `assets` folder, or might even use Rails' `activestorage`. The structure was basically broken up as follows:

- client: handles UI and keeping track of things needed on the frontend
- backend: handles everything else

After completing the course, many of my fellow students put up their projects on Heroku. This works well when your project is simple.

**DRY Methodology**:

This is less noticeable, but an important thing to consider. DRY stands for "Don't Repeat Yourself." Basically, if you have multiple blocks of code that do the same thing, you should abstract it out into a new function. I generally think about it from the opposite side: "each of your functions should do only one thing." DRY is a refactoring strategy, but I hope my method helps me write clean code in the first place.

## Services

When you use multiple APIs, each representing a different function, this is "Service Based Architecture."

Many mid-size companies or tech startups will have a service-based architecture. This means that they try to isolate different pieces of the business logic on the backend. Each service should reflect just _one_ thing that your app does on the backend. For example, a standard webapp could:

- handle user login status
- handle checkout/payments
- handle serving the frontend
- handle the images for your storefront

I spoke about a simple Rails API before. In those apps, we would write one backend to handle all of these functions. This is called a "monorepo" (or a monolith if your company is large enough). If you had a service-based architecture, you would split these functions out, and have a different backend for each one. There are a few existing services you could use for each of those functions:

- AWS IAM
- Stripe
- Github Pages
- AWS S3

And of course, you could write your own.

## But Why?
This conversation could be a million lines long. I think that services are most useful for two reasons:

- One service will not affect another.
- You can be lazy and let someone else handle the hard stuff.

### Service Encapsulation
If a service only relies on itself, it makes it much easier to test, and requires less debugging. For example, if our payment processor has logic that is intertwined with the login status, a bug in either of those areas may cause both to behave erratically. Ideally, the payment processor should be a different endpoint. It should only expect certain kinds of inputs. This will make it easier to test, because your testing scope is much simpler. If you have some sort of failure, it will be less likely to trickle down into other parts of your backend.

### Being Lazy
Setting up a working webserver can be a pain. For my Heroku apps, Heroku is abstracting some of the complications away. I don't have to buy physical server space to host my app. I don't have to deal with domain name shenanigans. Heroku runs several things behind the scenes that are hidden from you. I am familiar with NGINX, which is what Heroku uses to serve the actual app, but I do not want to spend my time fiddling around with it. It would be even worse for someone not familiar with any of the concepts. The one-click setup is beautiful.

If you have your own service, it should be very simple to interact with. Any team that needs to use the service will interact with it as an API. They will not need to know any fancy integrations, just how to make API calls.

## Creating a Service

We are getting into the weeds a bit here, and I intend this to be an introduction. I will try to be brief. If you wish to create your own service, there are a few directions you can go in. The most straightforward way is to use something like Heroku, write up a Rails API, and make calls to it for the functions you need. This option sits in the middle of a spectrum.

Hosting is a complex business, and all of the fancy technologies required to host your app can be obscured when using Heroku. However, even Heroku does not automatically handle everything. Heroku does not entirely handle things like load balancing, backups, and handling large spikes in traffic. If you want something that does, AWS Lambda is the ultimate set-and-forget. At the other end of the spectrum, you may want to handle the setup for these features. In that case, you could set up your own server space on something like Linode or AWS EC2, and handle the proxies and continuous releases yourself.

![AWS Responsibility Models](/assets/images/services/aws-responsibility-models.png)

## Cons

I think that these vary, depending on the service. S3 is relatively simple to set up, and can be used with basically any app. In this case, the setup is easier than handling image upload yourself.

This is not always the case. For example, AWS Lambda is a __big__ pain to set up. It needs a special interface or domain, can be finicky about its return values, and its online editor is not friendly. This is because Lambda handles everything you need for a server besides your business logic. For most of us, we can start small. 

## In conclusion

With starter projects, you will not often have a service-based architecture. However, it is useful to identify pain points and focus on those. You may find it useful to use an outside service instead of handling image upload in-app. If somebody else does it better, there is no need to reinvent the wheel. If you do it well, you may do better when you have more robust architecture.

Often you will find yourself using a pre-made service before you ever consider creating your own. Still, it is important to recognize where these pieces fit inside your structure.