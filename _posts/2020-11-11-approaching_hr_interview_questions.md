---
layout: post
title: "Preparing for Nontechnical Questions in a Tech Interview"
date: 2020-11-11 09:00:00 -0000
categories: Interviewing STAR 
---

{% include image.html url="/assets/images/nontechnical_interviews/sweating-towel-guy.png" description="More advice from someone who claims to know what they are doing." %}

Many guides exist for the basics of interviewing. I want to take it one step further. Much like the way I write [programming guides]({% post_url 2020-09-14-s3-heroku-rails %}) that are one step above beginner, this will be an interview guide for being one step above beginner.

We will take some introductory concepts, and extend them to make them more applicable.

Many of this will come from my coding bootcamp and career coach, and some of it will be inspired by my own experiences.

## Background
You should already have some preparatory work done. You should be familiar with the [STAR](https://interviewsteps.com/blogs/news/amazon-star-method) method to answer questions. You should also have planned out some questions that you may receive, and thought about the answers for them. [This](https://kate-travers.com/blog/posts/interview-prep-questions#questions-for-you) is an excellent list of questions to get started with.

You should also have checked the job description for any technologies you are unfamiliar with. You can use a resume comparer (I built a simple one you can use [here](https://elliott-king.github.io/resume-compare/)), or can just read through the job description.

## Preparing for the Interview
Remember, that your interviewer is _nontechnical_. They are part of the recruiting team or HR. As such, you should try to answer questions as generally as possible. This is also a test of your ability to communicate with future non-technical teammates.

### General Knowledge
You should expect to be asked about any general knowledge that appears in the job description.

Talking about general things is the easiest to prepare for. Often they will ask simple questions like:

- How familiar are you with Laravel or \[insert framework here\]?
- How familiar are you with Real Estate or \[industry\]?

Often, you will not have direct experience with a framework, but you can connect to something that you do have experience with. With a framework, you can connect to another framework. With an industry, you can talk about work you _have_ done that might be seen in that industry.

- I have not used Laravel specifically, but I am very familiar with Rails and Django, which are the Ruby and Python equivalent Model, View, Controller frameworks.
- On \[team\] I manipulated house pricing data, and for \[project\] I dealt with a lot of high-money sales. If I haven't done either of those, I can at least mention \[community project\], which makes housing an important subject to me.

That second one was a bit weak, but I am sure there are a lot of you out there who empathize with me. It is still better than simply saying "no."

### Why You are Interested in the Company
This can be open ended, but you should have an answer prepared. Usually I apply to companies that are mission-oriented, and appeal to me. I know that may not be true for you, but you can pretend it is.

This is also the piece that most benefits from a bit of extra research. You can open with talking about their mission and their product, but it is nice to throw a cherry on top. You interviewer will have heard similar statements from other applicants. At the end, you can mention that you read their blog post on \[mildly interesting topic\]. Don't go too into detail. People tend to remember conversations in a general manner, and remember the last topic the most. If you end with something unique, you will stand out.

### Preparing STAR Questions
You can try to predict what kind of STAR-style questions you will get. They will ask a few, and they will often reflect the requirements on the job description.

Look through the job description for the soft-skills and open-ended expectations. For each of these, write a STAR question for it. I find that the ones involving teamwork will be most common.

For example, a job description might contain something like these:
- Help build and orchestrate infrastructure and data pipelines.
- Work with marketing and analytics to decide how to best reach potential customers with the most impact.
- Ability to understand project requirements from a user perspective and make technical decisions that are in service of the goals of our clients.

Each of these just need "Tell me about a time..." to become STAR questions. For each bullet point, write it down and come up with a Situation-Task-Action-Response.

Finally, you should have answers prepared for some classic, general questions.
- Name a time you overcame a hard problem.
- Name a time you had a disagreement with a coworker.
- Why didn't you become a doctor like your brother? Your father and I sometimes worry about you.

## An Example
Let's take a look at an example job description, and try and predict what kind of questions we will get. I pulled this from a mid-size payments processor tech company.

> [Company] has grown into a platform of product services that help merchants run their business. From the inside, these product services are segmented into business units with their own product and engineering teams. Underneath, there's a platform organization that supports this plethora of products.
> 
> Our team, [Company] [Team], is part of this larger platform organization. We work with platform teams to help expose functionality of their services via internally accessible browser-based tooling. We build tools for quick and easy deployment, service provisioning, secret management, database monitoring, user administration and so on. We use the latest and greatest technology stack: React.js, TypeScript, Webpack, Jest and styled-components. Our goal is to write well tested, maintainable and readable code that could be understood by engineers with no front-end experience with little effort.
> 
> If this sounds interesting, here are some of the tasks that you would work on as part of our team:
> 
>     Develop, and deploy incremental improvements to our front-end platform.
> 
>     Write reusable components and libraries. 
> 
>     Write and review engineering design documents and guide product design.
> 
>     Work with many teams at [Company].
> 
>     Write clean, concise and well-tested code.
> 
>     Work autonomously with no micromanagement or oversight.
> 
> Qualifications
> 
> You have:
> 
>     2+ years of industry related experience
> 
>     Knowledge and understanding of the front-end development process (JavaScript, DOM, CSS).
> 
>     Troubleshooting skills through the entire stack, front-end to back-end.
> 
>     Experience with React.js stack.
> 
>     Good eye for UI and UX.
> 
> Technologies we use: TypeScript, React.js, Webpack, Antd, React Router, ESLint, Prettier, Jest, GraphQL, Styled Components, React Testing Library and many more.

__General Knowledge__

They mention their most important tools in paragraph two: `React.js, TypeScript, Webpack, Jest and styled-components`. `React` is definitely the most important, so you should be familiar with that. The rest of them are less important, but it is useful to at least know what they are. It is useful to know that `Jest` is a testing framework. Again, however, `React` will be most important. If this was a different role, there may be a few tools that are incredibly important.

__STAR Questions__

Looking at the technical requirements, you could pull out a few STAR questions as well. `Troubleshooting skills through the entire tech stack...` is an open-ended requirement, and there is a (slim) chance you will get asked about that. However, remember that you _are not speaking to a technical interviewer_. Talk a little about the tools, but you want to emphasize what larger skills you learned.

Looking at the softer requirements, here are some things I would pull out:
- `We work with platform teams to help expose functionality...`
- `Work autonomously with no micromanagement or oversight`
- `Work with many teams at [Company]` - alternatively, "When did you work hand-in-hand with another team you were unfamiliar with?"

You can form the bullet points into different questions. You can also adapt your existing answers if the interviewer asks you a question that is similar to one you have a prepared answer for.

## In Conclusion
- Read the job description.
- Make sure you can touch upon the hard skills if necessary.
- Prepare STAR questions for the soft skills in the job description.
- Interviewers can't smell fear, fortunately.