---
layout: single
title: "Following the Official AWS Amplify Guide and Getting Charged $1,100"
date: 2024-10-31 09:00:00 -0000
categories: aws typescript
excerpt: An interesting thing happens when you follow the official Amplify guide.
---

<link rel="stylesheet" href="/assets/styles/alerts.css">


| ![Allegory of Failure during the Pilgrimage of Life, by Monogrammist HSR, 1519](/assets/images/amplify_overcharge/allegory_failure.jpg "Allegory of Failure during the Pilgrimage of Life, by Monogrammist HSR, 1519") |
|:--:|
| *Allegory of Failure during the Pilgrimage of Life, by Monogrammist HSR, 1519* |

> **Elliott**
>
> I think the [OpenSearch] domains should have only been billed for part of the month, for one machine.
>
> The Amplify + OpenSearch behavior was unexpected. While I appreciate it if you waive my charges, I would also recommend raising this issue to the team in charge of documentation/implementation at Amplify.
>
> Name of the Service: Amazon OpenSearch Service
>
> Total Amount: 1,124.88
>
> Time Frame( in Days, Weeks and Months): One Month

> **AWS Customer Support**
>
> After a detailed review of your case and account, I'm happy to inform you that we've processed a billing adjustment for the unexpected charges as a one time courtesy.
>
> [...] Regarding your follow-up notes, I have reached out to the concerned team to investigate it further [...]

A few months ago, I was adapting an official guide for an AWS service. Specifically, [integrating OpenSearch with Amplify](https://docs.amplify.aws/react/build-a-backend/data/custom-business-logic/search-and-aggregate-queries/). I worked through the guide, and modified and debugged it for my own purposes. A few weeks later, I received an AWS bill for over $1200, and almost had a heart attack. I hadn't selected the most expensive OS instance type. I hadn't even used it much at all. I had worked with Amplify & OpenSearch back in 2020 (back when it still was ElasticSearch). It's pricey for personal use, usually around $50 per month, but not crazy.

I opened a support ticket with AWS. I narrowed down what happened. There were a few behaviors with Amplify + OpenSearch that I felt were oversights. The response from AWS was prompt. They had me set up a budget alert and gave me service credit for both OpenSearch and its storage. Kudos! Even if you are not using Amplify/OpenSearch, I recommend getting familiar with AWS [budgets](https://aws.amazon.com/aws-cost-management/aws-budgets/). They predict future spend, for a service or for AWS as a whole, and can send you alerts if you are projected to break them. However, I was terrified from that experience, and set the project, and Amplify, aside.

I came back to it recently and... The behavior still exists! This post exists to caution the reader about using AWS Amplify, especially with OpenSearch. That said, let's jump into how you can rack up thousands of dollars of compute by just following the official guide.

## 1. Follow Quickstart
The [quickstart](https://docs.amplify.aws/react/start/quickstart/) is pretty straightforward. You spin up a toy app, with code provided by AWS, that includes DB schema for TODO notes. Amplify creates a DynamoDB database as well as authenticated CRUD requests for you. You also get a nice login flow, and it intelligently only shows the right TODOs to the right users. You can run it locally, but Amplify also creates a domain that you can visit.


Enjoy the cute formatted build status update:
```
✨ hotswapping resources:
   ✨ AWS::AppSync::ApiKey '******'
✨ AWS::AppSync::ApiKey '*******' hotswapped!

 ✅  amplify-amplifyvitereacttemplate-mymac-sandbox-xxxx

✨  Deployment time: 4.82s

```

Here is what the webapp looks like:

| ![Webapp after quickstart](/assets/images/amplify_overcharge/screenshot_initial_app.png "Webapp after quickstart") |
|:--:|
| *Webapp after quickstart* |

## 2. Follow Guide for OpenSearch Setup
[The next part I followed](https://docs.amplify.aws/react/build-a-backend/data/custom-business-logic/search-and-aggregate-queries/) involves writing a bunch of Typescript boilerplate for the Amplify to declare your resources. You don't need to commit this to memory, but here's a quick overview:
- set DynamoDB table as a variable so we can reference it elsewhere and use it in the pipeline
- create an OpenSearch instance, index, and indexMapping (where you declare the fields & their types)
- write a query to access the data living in OpenSearch
- create an OpenSearchIngestionService pipeline to copy from DDB -> OS

All of this is written in Typescript/Javascript, and lives in your repo with the frontend code. The CLI command is `npx ampx sandbox`, which spins up the AWS services. It detects changes to your configuration, and automatically modifies the existing AWS services as needed.

At this point, we have a DynamoDB database, one OpenSearch service, one OSIS pipeline, and various other things (like IAM roles).

{% include alert.html content="As an aside, this setup creates mid-price `r5.large.search` OpenSearch instances by default. Nowhere in the boilerplate code or guide is this mentioned. That will run you $134 per month at minimum." %}

| ![t3.small.search instance pricing: $0.036 per hour](/assets/images/amplify_overcharge/small_pricing.png "t3.small.search instance pricing: $0.036 per hour") |
|:--:|
| *t3.small.search instance pricing* |

| ![r5.large.search instance pricing: $0.186 per hour](/assets/images/amplify_overcharge/r5_large_pricing.png "r5.large.search instance pricing: $0.186 per hour") |
|:--:|
| *r5.large.search instance pricing* |


## 3. Shut it Down for the Day
Nice job, you are done with work for the day. You hit `CTRL-C` and stop your sandbox. It asks if you want to delete everything permanently. Not wanting to go over budget, you say "Y".

If you were a smarter cookie than me, you may double-check the AWS console. Is everything gone? DynamoDB is gone, but your OpenSearch domain is still there!

## 4. Spin it back up
You come back in the morning and re-create your services. You need an OpenSearch instance, but `npx ampx sandbox` will create a new one. In fact, running `npx ampx sandbox delete` will not delete your original instance. You suddenly have two OpenSearch domains! Rinse and repeat a few times, and you will find yourself with multiple domains in the background, ticking up to thousands of dollars in dues to AWS.


| ![Two OpenSearch domains](/assets/images/amplify_overcharge/two_domains.png "Two OpenSearch domains") |
|:--:|
| *Two OpenSearch domains created for the same project* |

## Is This a Bug?

I certainly think so, but it hasn't been addressed since my customer support ticket with AWS. This seems like a huge footgun. There are [a few old bug reports](https://github.com/aws-amplify/amplify-cli/issues/10523), but I did not find anything from less than a year ago. Perhaps the OpenSearch domain was correctly deleted in v1, but no longer in v2. Regardless, it's now run through `npx`, not the Amplify CLI.

In addition, I am also irked by the fact that the `r5.large.search` is the default machine type. In my opinion, there shouldn't be a default at all, it should be a required field. The _guide_ should default to `r5.large.search` so it's more visible to the user. This default is not Amplify-specific, however, so I don't blame the Amplify team. It's part of the AWS CDK.

# Conclusion

A certain section of readers will be quick to say, "you should understand what you are working on" or "you should double check pricing." That is technically correct, but misses the point. It's so difficult to be paranoid about every single technology you use. When using new technologies that promise to speed up the developer flow, I already expect them to be more expensive than bare metal, but I think this is beyond the pale. It's again worth noting that AWS does have a "budget" console, and you can use this to receive alerts to warn if you are projected to go over budget. In fact, AWS required me to set up a budget before sending me credit for the unused OpenSearch domains.

I'm not sure if Amazon doc writers expect you to double-check all this. It's a complicated piece of technology at a complicated company, so I think it's more likely an oversight than intended behavior. There is so much going on within the Amplify guide. Just [within the OpenSearch section](https://docs.amplify.aws/react/build-a-backend/data/custom-business-logic/search-and-aggregate-queries/), it creates IAM accounts, an OpenSearch domain, an OSIS pipeline, a log group, and s3 storage. Because OpenSearch is often used for enterprise customers, I wonder if OpenSearch is considered "advanced," and users of OS are expected to have a stronger understanding of the AWS ecosystem. I'll admit that I myself am only using OpenSearch because it supports `geo_point` bounding-box queries, a subject that I don't have a full understanding of. Perhaps there is a way to do these with a simpler product, and OpenSearch is overkill. Perhaps this relates to a larger problem: it's difficult to figure out what you need when you start with conscious incompetence on the internet.
