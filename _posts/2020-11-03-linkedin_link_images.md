---
layout: single
title: "Improving your Website Preview Cards on LinkedIn"
date: 2020-11-03 09:00:00 -0000
categories: LinkedIn HTML OGP 
---

LinkedIn has a nice feature of "unfurling" links. When you add a URL in a post or your "featured" profile section, LinkedIn will show a small preview of the site you are linking to. This includes a title, description, and image. 

{% include image.html url="/assets/images/li_images/post_yes_image.png" description="A new post with a preview title and image." %}

However, you might notice that when you host a personal project and share it on LinkedIn (or any social network, really), it may not show a description or title, and it almost certainly will not show an image. It also will not give you the option to input an image, even within the "featured" section.

{% include image.html url="/assets/images/li_images/post_no_image.png" description="A new post with no preview image." %}

If you share a link from Medium, Twitter, or IMDB, it will always have an image. What can you do to fix this for your own webapps?

## How LinkedIn Gets Metadata

LinkedIn is not going to scrape your entire page to try and infer the title and image. Instead, it looks at the `<meta>` tags in your HTML's `<head>`. "Title" and "description" tags are pretty standard, but it also looks for meta tags that are of the "Open Graph Protocol" type. This protocol was created by Facebook to more easily make a graph of websites. It is very involved, but we will only need three tags:

```html
<meta property='og:title' content='My Title'/>
<meta property='og:image' content='URL to the image you want in the preview'/>
<meta property='og:description' content='This should be a short description'/>
```

LinkedIn will prioritize these OGP meta tags, then fall back on the standards. If you already have the normal `title` and `description` meta tags, you may see these autofilled on LinkedIn. 

As long as your image url is correct, you should see an image in the preview. Additionally, your "featured" section should also include the image. Before, you would see this:

{% include image.html url="/assets/images/li_images/featured_no_image.png" description="A link in my 'featured' section without an image." %}

Now, you should see some nice tiles:

{% include image.html url="/assets/images/li_images/featured_yes_image.png" description="Links in my 'featured' section with an image." %}

Additionally, if you post your link to Twitter, Facebook, and Slack, this will also have the positive side effect of creating a preview there as well!

### A Quick Note on LinkedIn's Cache

If you recently changed the `head` and `meta` properties of your site, the previews may not immediately show this. This is because LinkedIn caches a lot of this information. You can use LinkedIn's [post inspector](https://www.linkedin.com/post-inspector/) to force LinkedIn to show you what the preview will look like.

### Final Thoughts and Resources

For more technical information on what tags LinkedIn looks for, look [here](https://www.linkedin.com/help/linkedin/answer/46687).

You can also include multiple different sizes of images. Different websites may have different defaults. For a more in-depth look into unfurling, look [here](https://medium.com/slack-developer-blog/everything-you-ever-wanted-to-know-about-unfurling-but-were-afraid-to-ask-or-how-to-make-your-e64b4bb9254).

For the documentation and use cases of Facebook's Open Graph Protocol, look [here](https://opengraphprotocol.org/).