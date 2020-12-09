---
layout: single
title: "An Introduction to Search Engine Optimization"
date: 2020-12-09 09:00:00 -0000
categories: web-development seo html google
excerpt: Optimize your site for search engines, or something like that.
---

<figure class="image">
  <img src="/assets/images/seo/paulius-dragunas-Nhs0sLAn1Is-unsplash.jpg" alt="Photo of a lighthouse.">
  <figcaption>Photo by <a href="https://unsplash.com/@paulius005?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Paulius Dragunas</a> on <a href="https://unsplash.com/s/photos/lighthouse?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></figcaption>
</figure>

Your personal web site may not show up on the first page of Google's search results. In fact, Google may not have it stored at all! Eventually, however, you may want your site to appear within a Google search. This is called *Search Engine Optimization*, or SEO. Although "search engine" sounds general, most people only care about Google search, so we will focus on that. Google does have over 90% share of searches, after all.

<figure class="image">
  <a href="https://www.digitalinformationworld.com/2020/08/2020-search-engine-market-share-google-leads-by-a-huge-margin.html" target="_blank">
    <img src="/assets/images/seo/search-engine-share.png" alt="Search engine market share, courtesy of Digital Information World.">
  </a>
  <figcaption>Search engine market share, courtesy of Digital Information World.</figcaption>
</figure>

The interesting thing about SEO is that it overlaps with a few other important site features. For example, I previously wrote about [social media preview cards]({% post_url 2020-11-03-linkedin_link_images %}), which is what shows up on social media when you include a link. The preview cards are based on some tags that are used by Google's web crawlers. Additionally, Google will check to see if your website is responsive, uses HTTPS, and a myriad of other things. Let's just look at the basics.

Basically, the idea is that Google has a [couple of things it looks for](https://developers.google.com/search/docs/advanced/guidelines/webmaster-guidelines) when crawling your site. The guide I just linked is very comprehensive, but a bit dense and long. Most of this we can check with a simple tool. Before that, I recommend you just check if your site is on Google - you can do this by directly searching for your site. For example, I would search `site:elliott-king.github.io`, and the results should all link to my personal site.

## Google Lighthouse

Fortunately, rather than read through the guide, we can just run a tool to tell us what to do. This tool is [Google Lighthouse](https://developers.google.com/web/tools/lighthouse/). You can run it on the command line, but it can also be run straight from the browser. In Chrome, it is part of the dev tools. In Firefox, you will need to install the [add-on](https://addons.mozilla.org/en-US/firefox/addon/google-lighthouse/). 

The tool just asks Google to look at your site, and generate a report of it.

{% include image.html url="/assets/images/seo/my-report.png" description="Report for elliott-king.github.io at the time of posting this." %}

You can jump down to the "SEO" section once you generate a report. Remember, this tool only covers the basics!

Fortunately, my [current website theme](https://github.com/mmistakes/minimal-mistakes/) handles the basic SEO for me. However, that has not always been the case. Once upon a time, I had to manually create a `sitemap.xml`.

Under the "SEO" section, you will see a short list of requirements, and whether or not you have fulfilled them. This is what makes Lighthouse so useful. You do not have to understand SEO beforehand, you can instead just lean on Lighthouse to understand it for you! Under each section, there is a short description, and usually a link if you need to know more. 

Once you have everything complete in the "SEO" section, it is good to take a look at the other sections. Google does use these for page rankings, especially the "Best Practices" and "Accessibility." Google search [will prefer an HTTPS](https://developers.google.com/search/docs/advanced/security/https?hl=en#more-information) site over HTTP. 

Finally, you should make sure to run Lighthouse for mobile as well as desktop, which should be under "options" within Chrome Dev Tools or the Firefox add-on. Mobile can be more stringent. You can see above that I scored an 87 on "Performance" on mobile, but on desktop it gives me a 93.

Congratulations! Once you have all of this covered, you have left the little leagues. Welcome to the wild world of bending your website to fit the whims of Google Search.

## Further Consideration

To go into advanced SEO, you will want to take a deeper dive into the link I put above - the Google [webmaster guidelines for SEO](https://developers.google.com/search/docs/advanced/guidelines/webmaster-guidelines). Additionally, there are some things that are tougher to implement. Part of your page's rank is based upon how many [trusted sources link to your content](https://www.investopedia.com/articles/personal-finance/042415/story-behind-googles-success.asp). It is hard to get other people to link to you. This is part of the reason why social media sites rank so highly even if they have little relation to your search terms.

There are many, many things you can add to your site. People spend entire careers on Search Engine Optimization. Start with the basics, and then go from there.