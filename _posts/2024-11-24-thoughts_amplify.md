---
layout: single
title: "Thoughts on AWS Amplify"
date: 2024-11-24 01:00:00 -0000
categories: aws typescript
excerpt: A belated writeup on my experience working with Amplify.
---
> DISCLAIMER
>
> I wrote this Nov 2024, but my original notes are from July. I referred to the docs while rewriting this, but some things have been fixed (mentioned below). This post exists because I wanted to flesh out my notes and finally put my pen to paper. Do not take it as up-to-date as of the publish time.
>
> This is for Amplify v2.
>
> I used DynamoDB and OpenSearch. Many problems relate to OpenSearch integration. If you are not using OS, you will have fewer issues.

AWS Amplify is Amazon's all-in-one infra and full-stack creation tool. You write everything in Typescript (mostly) including serverless infrastructure configuration. It's billed as a "frontend DX [developer experience] for AWS". I'm just going to come out right away and say that I think it has problems. However, I'll talk a bit about who might want to use it, and why I feel it doesn't work well.


# Why try Amplify?
For me, there were a few attractive aspects. The main one is centralization. Your serverless service setup is all written in TypeScript and lives in the same repo as your app. In theory, the documentation of each service (eg, DynamoDB docs) translates easily to the Amplify creation of that service (eg, following the DynamoDB docs but writing TS code within the Amplify framework). In my case, I wanted to use DynamoDB and OpenSearch. I wanted a data pipeline to continually update OS from DDB. Conveniently, Amplify has a guide to support this specific case.

The user auth for the app is also manageable from the same spot. AWS does an excellent job intertwining this with the auto-created CRUD functionality. With Amplify, you set up your auth and DB schema with a few lines. Amplify will then create JS CRUD methods with authentication baked-in. This partially extends to more complicated queries - you can have to write/design your API GraphQL queries, but the auth is still baked-in by Amplify. You can also easily connect your DB objects to the user who created them. Not having to think about auth setup for your queries is a huge mental load off of my head.

# The TL;DR of My Concerns
- the docs and intro guides are unreliable (especially for OpenSearch)
- things don't fail fast
- error output for serverless infra is not great
  - this is at odds with this being "easy to start"
- it just feels like a beta product

# The Problems
## Amplify Feels Like a Beta Product
Many aspects do not feel fully-formed. This is a larger problem, and many of the following sections will contribute to this. However, let me start with a small example. Looking at the guide to [create a custom query](https://docs.amplify.aws/angular/build-a-backend/data/custom-business-logic/search-and-aggregate-queries/#step-4b-create-resolver-and-attach-to-query). This resolver file has to be Javascript. It cannot be TypeScript. I had a weird feeling while writing that file, like "okay, that's weird, but I guess I can deal with it". I initially tried to write a TS resolver file, but it failed, and I needed to re-try and re-build the AWS services. This contributes to my impression that the docs are sloppy.

Many of the following issues feed into this.

## The Docs and Guides Don't Feel Reliable
### The Quickstart Does Not Fail Fast
During the [create user with Amplify permissions](https://docs.amplify.aws/react/start/account-setup/#1-create-user-with-amplify-permissions) step, I enabled IAM Identity Center within *my account*, instead of *within an organization*. This was my mistake, but I continued onwards without realizing. A few commands silently failed, and eventually a command truly failed and broke the whole app. At that point, it was not obvious that the problem had occurred several steps before.

This is my fault - user error. I would normally forgive such issues, but combined with everything else, it's a bit annoying. Again, many of the following issues feed into this annoyance.

### LogGroup Name (fixed)
As part of the guide to [set up OpenSearch](https://docs.amplify.aws/angular/build-a-backend/data/custom-business-logic/search-and-aggregate-queries/#step-3b-opensearch-service-pipeline), I got this error:
```
Properties validation failed for resource FreedomIntegrationPipeline with message:
#/LogPublishingOptions/CloudWatchLogDestination/LogGroup: failed validation constraint for keyword [pattern]
```

This `logGroupName` is used and inserted into the OpenSearch Ingestion Service (OSIS), which pipelines the data from DDB to OS.

I was pretty sure this is comment is about the `logGroupName`, but the error is unclear about what part of the name is incorrect. At the time, in the guide, this was the recommended log group name:
```typescript
// amplify/backend.ts
const logGroup = new logs.LogGroup(dataStack, "LogGroup", {
  logGroupName: "/aws/vended-logs/OpenSearchService/pipelines/1",
  removalPolicy: RemovalPolicy.DESTROY,
});
```

The error output is obviously not great, so here's the issue I found: it needs to be `vendedlogs`, not `vended-logs` (NOTE: this has been fixed in the docs as of the writing of this post). There are [docs for the loggroup name](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html), but they don’t cover these failure modes. There’s some rules that exist, but are not mentioned, so I had to muddle through it myself.

On top of that, I had an amusing experience while debugging. I set the value as a variable instead of passing in from the object. eg:
```typescript
const myLogGroupName = "/aws/vended-logs/OpenSearchService/pipelines/1";
```

I then added variable to the two blocks that need it. The second block previously used logGroup.logGroupName to access it. After this, I got a slightly more useful error:
```
[#/LogPublishingOptions/CloudWatchLogDestination/LogGroup: string [/aws/vended-logs/OpenSearchService/pipelines/1] does not match pattern \/aws\/vendedlogs\/[\.\-_/#A-Za-z0-9]+]
```

Thanks, a readable error! Why is the error output less useful if you use the `logGroup.logGroupName` style...? That meant this was a problem both with the documentation, and ALSO the error output.

## The Intro OpenSearch Guide Set Me up for A $1200 Monthly Charge (fixed after a while)
I mentioned this in a [previous blog post]({% post_url 2024-10-31-amplify-overcharge %}), but just following the Amplify + OpenSearch introductory guide opened me up to being overcharged like crazy. However, as of publishing these notes, I can say that they have improved the guide! I'm not over the moon, because it took them several months, but at least it shows progress.

## Troubleshooting OpenSearch Resource/Backend Errors is Time Consuming
Again, I wanted to set up OpenSearch so I could use location bounding-box queries. Amplify has a guide for [OpenSearch setup](https://docs.amplify.aws/react/build-a-backend/data/custom-business-logic/search-and-aggregate-queries/). This involves adding OS to `backend.ts` and hooking it up to your DB. I followed the steps to the end of step 3, and was working on the OSIS pipeline. This includes the log group and pipeline setup mentioned above. At this point, the `npx ampx sandbox` command (which creates a backend environment) takes a long time:
- raw: ~37 minutes (33 minutes until error triggered, 3 addtl minutes for delete/rollback)
- after each `logGroupName` change: ~38 minutes (29 minutes until first error, 9 minutes for delete/rollback)

I tried deleting all CloudFormation and re-running the sandbox creation from scratch. This still took 30 minutes.

All of this made debugging the `logGroupName` above excruciating. I don't have much to say about this, except that I'm surprised I continued on in hindsight.

## OpenSearch Setup/Logging (fixed)
This was fixed as of the time of this post.

Again, I had problems with OpenSearch not failing fast. I had made a mistake in my index mapping declaration. Instead of `type: text`, I used `type: string` and got "failure opening selector" log output. To their credit, I [opened an issue](https://github.com/opensearch-project/data-prepper/issues/4717), and they did address it after about a month.

## OpenSearch Integration is Flaky and Difficult to Debug
Some of this is the Amplify-OpenSearch integration. Some is OpenSearch itself, but it's hard to tease out the problem because they are tightly coupled. It makes the whole package more frustrating. Some examples:

Supposedly, you can cURL the OS domain from your terminal or the AWS console. However, it is unclear how to do this, and what permissions are created by the Amplify pipeline. All I get is a vague permissions error. Similarly, I had trouble finding out how to open the OpenSearch dashboard for a domain.

The OpenSearch mapping of `geo_point` for my `location` field did not work due to some error I never fully tracked down. My `location` was instead using floats. I corrected the field, but it did not update the service remotely. I had to delete the CloudFormation stack and OpenSearch domain, then fully rebuild. Similarly, I had a later issue with a `date` field. After updating the field, the OS domain was not updated. It again needed a full reset.

Amplify says it can be used for production environments. But how could I trust it with this behavior?

# In Conclusion

## The Benefits
They are obviously working on it. It's a slow process, though, possibly because they need to work with several different service teams to roll out changes.

I appreciate Amplify somewhat because it helped me with big-picture thinking. It feels like AWS is trying to communicate best practices for serverless webapp design, and Amplify is the collection of that knowledge. Working with Amplify changed how I think about infrastructure, and what I need when designing project infrastructure. This spans from tiny details (DynamoDB needing PITR while using a data pipeline), to the larger (different layers of authentication needed, either for myself or my potential users). It doesn't give me as much understanding of serverless as I would like, but I appreciate it regardless.

## What Would I Expect Before Considering this Production Ready?
All of this just adds up to the feeling that Amplify is a beta product, has an unclear target audience, and not at all well tested.

The main issues are validation and error logging. The error logging is frequently unclear. The validation of my `backend.ts` file needs to happen before it starts spinning up services. `npx ampx sandbox` takes a long time to run, but that would be forgivable if it failed faster. Debugging is both confusing and sluggish.

The docs also need to be more reliable. Although the docs are fixed faster than other bugs, these fixes come in slowly.

I feel like there is a gap between implementation and understanding. Amplify sets up your serverless architecture, but everything is so intertwined and automatic. What if I wanted to transition to managing it myself? What if I still wanted to use AWS, but just manage each individual service instead of Amplify? Each change would be similar to starting from scratch.

So what kind of user does this target? I think you could use this if you do not expect to change your infrastructure outside Amplify's limited bounds, and appreciate quickly setting up authenticated endpoints. Auth being baked-in is huge, in my opinion. It just makes quick setup so simple. But in the tradeoff between convenience and working on tooling myself, this feels like it swings too far away from understanding of tooling, and still doesn't deliver enough on the convenience. If you are a newbie, the guide does not hold your hand enough and the technology feels opaque. If you are experienced, it would be difficult to extend your Amplify app into anything not controlled by Amplify, or take more control for yourself.