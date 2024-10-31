---
layout: single
title: "Following the Official AWS Amplify Guide Caused me to Owe $1,100"
date: 2020-10-31 09:00:00 -0000
categories: aws typescript
excerpt: An interesting thing happens when you follow the official Amplify guide.
---

> [!Elliott]
> I think the [OpenSearch] domains should have only been billed for part of the month, for one machine.
> Name of the Service: Amazon OpenSearch Service
> Total Amount: 1,124.88
> Time Frame( in Days, Weeks and Months): One Month

...

> [!AWS]
> I have reviewed your support case regarding the unexpected spike in charges from OpenSearch Service on your account.
>
> I would request you respond back to us with following details, so that we can built a strong use case while requesting for a possible billing adjustment with the Service team:

...
> [!Elliott]
> The Amplify + OpenSearch behavior was unexpected. While I appreciate it if you waive my charges, I would also recommend raising this issue to the team in charge of documentation/implementation at Amplify.

...

> [!AWS]
> After a detailed review of your case and account, I'm happy to inform you that we've processed a billing adjustment for the unexpected charges as a one time courtesy.
>
> [...] Regarding your follow-up notes, I have reached out to the concerned team to investigate it further [...]

I ran into an odd experience a few months ago. I was adapting a guide for an AWS service. Specifically, [integrating OpenSearch with Amplify](https://docs.amplify.aws/react/build-a-backend/data/custom-business-logic/search-and-aggregate-queries/). I worked through the guide, and modified and debugged it for my own purposes. A few weeks later, I received an AWS bill for over $1200, and almost had a heart attack. No, I hadn't requested to use the most expensive OS instance type. I had worked with Amplify & OpenSearch back in 2020 (back when it was still ElasticSearch). It's pricey for personal use, usually around $50 per month, but not crazy.

I opened a support ticket with AWS. I narrowed down what happened. There were a few behaviors with Amplify + OpenSearch that I felt were oversights. The response from AWS was prompt, and they gave me service credit (as well as making me promise to set up a budget alert). Kudos! But, I was terrified from that experience, and set the project, and Amplify, aside.

However, I came back to it just recently and retried this. The behavior still exists! Even if you are not using Amplify/OpenSearch, I recommend getting familiar with AWS [budgets](https://aws.amazon.com/aws-cost-management/aws-budgets/). They predict future spend, for a service, or for AWS as a whole, and can send you alerts depending. This post also exists to caution the reader about using AWS Amplify, and especially OpenSearch with it. That said, let's jump into how you can add thousands of dollars of bills with just a few accidental changes in AWS Amplify.

## 1. Follow Quickstart
The [quickstart](https://docs.amplify.aws/react/start/quickstart/) is pretty straightforward. You spin up a toy app, with code provided by AWS, that includes DB schema for TODO notes. Amplify creates a DynamoDB database as well as authenticated CRUD requests for you. You also get a nice login flow, and it intelligently only shows the right TODOs to the right users. You can run it locally, but Amplify also creates a domain that you can visit.


Enjoy the prettily formatted build status update:
```
✨ hotswapping resources:
   ✨ AWS::AppSync::ApiKey '******'
✨ AWS::AppSync::ApiKey '*******' hotswapped!

 ✅  amplify-amplifyvitereacttemplate-mymac-sandbox-xxxx

✨  Deployment time: 4.82s

```

Here is what the webapp looks like:

<!-- fixme: image of app with some todos -->

## 2. Follow Guide for OpenSearch Setup
[This part](https://docs.amplify.aws/react/build-a-backend/data/custom-business-logic/search-and-aggregate-queries/) involves writing a bunch of Typescript boilerplate for the Amplify resources:
- some specification for the DynamoDB table so we can reference it elsewhere and use it in the pipeline
- create an OpenSearch instance, index, and indexMapping (which is where you declare the fields & their types)
- write a query to access the data living in OpenSearch
- create an OpenSearchIngestionService pipeline to copy from DDB -> OS

Here is the index mapping, for future reference:
```typescript

// Define OpenSearch index mappings
const indexName = "todo";


const indexMapping = {
  settings: {
    number_of_shards: 1,
    number_of_replicas: 0,
  },
  mappings: {
    properties: {
      id: {
        type: "keyword",
      },
      done: {
        type: "boolean",
      },
      content: {
        type: "text",
      },
    },
  },
};
```

Note that all of this is written in Typescript/Javascript, but also lives in your repo with the frontend code. The key command is `npx ampx sandbox`, which spins up the services. I have left this running since part 1. `npx ampx sandbox` detects changes to your configuration, and automatically modifies your services as needed.

At this point, we have a DynamoDB database, one OpenSearch service, one OSIS pipeline, and other extraneous things (like IAM roles).

> [!WARNING]  
> The OpenSearch setup creates an `r5.large.search` instance, which is larger & more expensive. Nowhere in the boilerplate code is this mentioned (since it's the default). That will run you $134 per month at minimum (probably more since you will have some storage as well). I hope you were paying attention. That is 5x the cost of the entry-level `t3.small.search` tier.

| ![t3.small.search instance pricing](/assets/images/amplify_overcharge.small_pricing.png "t3.small.search instance pricing") |
|:--:|
| *t3.small.search instance pricing* |

<!-- fixme: include price in alt text -->

| ![r5.large.search instance pricing](/assets/images/amplify_overcharge.r5_large_pricing.png "r5.large.search instance pricing") |
|:--:|
| *r5.large.search instance pricing* |


## 3. Shut it Down for the Day
Nice job, you are done with work for the day. You hit `CTRL-C` and stop your sandbox. It asks if you want to delete everything permanently. Not wanting to go over budget, you say "Y".

If you were a smarter cookie than me, you may want to double-check in the AWS console. Is everything gone? DynamoDB is, but your OpenSearch domain is still there!

You come back in the morning and re-create your services. You need an OpenSearch instance, but `npx ampx sandbox` creates a new one. In fact, running `npx ampx sandbox delete` will not delete your original instance. You suddenly have two OpenSearch domains! Rinse and repeat a few times, and you will find yourself with multiple domains in the background, ticking up to thousands of dollars in dues to AWS.


| ![Two OpenSearch domains created](/assets/images/amplify_overcharge.r5_large_pricing.png "Two OpenSearch domains created") |
|:--:|
| *Two OpenSearch domains created* |

## Is This a Bug?

I certainly think so, but it hasn't been addressed since my customer support ticket with AWS. I am also irked by the fact that the `r5.large.search` is the default machine type. In my opinion, there shouldn't be a default at all, and it should be a required field. This seems like a huge footgun. There are [a few old bug reports](https://github.com/aws-amplify/amplify-cli/issues/10523), but I did not find anything from less than a year ago. Perhaps the OpenSearch domain was correctly deleted in v1, but no longer in v2. Regardless, it's now run through `npx`, not the Amplify CLI.

# Conclusion

I'm not sure if Amazon doc writers expect you to double-check all this. It's a complicated piece of technology at a complicated company, so I think it's more likely an oversight than intended behavior. There is so much going on within the Amplify guide. Just within the OpenSearch section, it creates IAM accounts, an OpenSearch domain, an OSIS pipeline, a log group, and s3 storage. Because OpenSearch is often used for enterprise customers, I wonder if OpenSearch considered "advanced," and users of OS are expected to maintain a stronger understanding of the AWS ecosystem. I'll admit that I am only using OpenSearch because it supports `geo_point` bounding-box queries, a subject that I don't have a full understanding of. Perhaps there is a way to do these with just DynamoDB or a simpler product, and OpenSearch is overkill.

A certain class of reader will be quick to say, "you should understand what you are working on" or "you should double check pricing." I think that is technically correct, but misses the point. It's so difficult to be paranoid about every single technology you use. When using new technologies that promise to speed up the developer flow, I already expect them to be more expensive than bare metal, but I think this is beyond the pale. It's worth noting that AWS does have a "budget" console, and you can use this to receive alerts to warn if you are projected to go over budget. In fact, using this was one of the requirements to receive credit from AWS.

<!-- fixme: mention that they told me to add a cost management budget -->
- can be hard to identify what is truly for newbies
  - should I not have used OS to connect to DDB & make geo queries?
- Amazon guide writers assume you will double-check all this...?
  - so much going on in this guide. Only in OS section

a certain class of reader will be quick to say, "you should understand what you are working on" or "you should double check pricing these days"
- tech is moving ahead at a breakneck pace. somethings are customer-friendly, some are not.
- its so difficult to be paranoid about everything
- not entirely clear what is best option for geo point search
- handles integration b/w ddb & OS incredibly well

## 3. Make a Small Index Mapping Error

### Add "for" string to model

Let's modify our model, and add a `for` string, like I have to finish this TODO for my lovely wife or maybe for one of my six children. We add the field to the frontend, and to the DynamoDB resource schema. Simple enough. But then, we add it to the DynamoDB instance mapping and make a mistake:
```typescript
const indexMapping = {
  settings: {
    number_of_shards: 1,
    number_of_replicas: 0,
  },
  mappings: {
    properties: {
      id: {
        type: "keyword",
      },
      done: {
        type: "boolean",
      },
      content: {
        type: "text",
      },
      for: {
        type: "string",
      },
    },
  },
};
```

This is basically the mistake I made originally. I had added `booleans`, `dates`, and `geo_points`, and forgot that the correct field type was "text", not "string".

### Realize Your Mistake

Your queries will still work, but the `for` field won't show in the AppSync console, and DynamoDB will no longer send new rows to OpenSearch. The integration pipeline will have this error:
```
`Failed to initialize OpenSearch sink with a retryable exception.
org.opensearch.client.util.MissingRequiredPropertyException: Missing required property 'Builder.<variant kind>'`
```

Not terribly helpful, but ok. Eventually, you realize that the problem is the field type.

### Whoops, Correct the Index
Your rows will now show up when queried in AppSync. In fact, it will backfill the missing ones from when the mistake was active. Not bad.

This took 30 minutes. After OSIS:
```
Stack ARN:
arn:aws:cloudformation:us-east-1:XXX:stack/amplify-amplifyvitereacttemplate-mymac-sandbox-XXX/uuid

✨  Total time: 1501.31s
```

Key command here is `npx ampx sandbox`, which I have running in bg.
End with one service.

The created domain is `r5.large.search`. Nowhere in the boilerplate code is this mentioned (since it's the default). That will run you $134 at minimum. I hope you were paying attention. That is 5x the cost of the entry-level `t3.small.search` tier.





### add to DDB & wait
8.45 s setup, domains the same

### Add incorrect index:
```
      for: {
        type: "string", // should be "text"
      },
```
5 minute setup

Seeing log error: `Failed to initialize OpenSearch sink with a retryable exception.
org.opensearch.client.util.MissingRequiredPropertyException: Missing required property 'Builder.<variant kind>'`

Add new post with "for" field. Does not increase count in OS. Does not show up in Apsync query. `for` field not in appsync explorer

### whooops, correct the index
now shows up in OS index overview
row is automagically added