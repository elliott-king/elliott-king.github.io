---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

description: I am a developer in New York City. I have experience all across the board, from Ruby/Rails and React, to some machine learning.
layout: splash
# author_profile: true
permalink: /

header:
  overlay_color: "#000"
  overlay_image: /assets/images/gradient.png
  # caption: "Gradient from [Coolers](https://coolors.co)"
excerpt: "Full-stack is the intersection of hard problems and seeing your project grow into a living being."

projects_row1:
  - image_path: assets/images/project-screenshots/res-compare.png
    alt: "Resume Checker Screenshot"
    title: "ATS Resume Checker"
    excerpt: "Looks through your resume and job description for shared keywords."
    btn_label: "Visit"
    btn_class: "btn--primary"
    url: "https://elliott-king.github.io/resume-compare/"
    github_url: "https://github.com/elliott-king/resume-compare"
  - image_path: assets/images/project-screenshots/bill-tracker.png
    alt: "Bill Tracker Screenshot"
    title: "NYS Bill Tracker"
    excerpt: "Search through current NYS Senate bills. Collaboration for [Astoria Digital](https://astoria.digital/) volunteer organization."
    btn_label: "Visit"
    btn_class: "btn--primary"
    github_url: "https://github.com/astoria-tech/bill-tracker"
  - image_path: assets/images/project-screenshots/adversity.png
    alt: "Adversity Job Board Screenshot"
    title: "Adversity Job Board"
    excerpt: "A job board for when you want your applicants to REALLY work for it."
    btn_label: "Visit"
    btn_class: "btn--primary"
    github_url: "https://github.com/elliott-king/adversity-board-frontend"
    youtube_url: "https://www.youtube.com/watch?v=5OK3An-Jqes"

projects_row2:
  - image_path: assets/images/project-screenshots/creepy-tracker.png
    alt: "Screenshot of Creepy Tracker"
    title: "Creepy Tracker"
    excerpt: "A website that builds a simple fingerprint for your browser. If you are interested in browser fingerprinting, I also wrote an [introduction](https://elliott-king.github.io/2020/05/fingerprinting-i/)."
    btn_label: "Visit"
    btn_class: "btn--primary"
    github_url: "https://github.com/elliott-king/freedom-js-app"
  - image_path: assets/images/project-screenshots/freedom.png
    alt: "Freedom JS"
    title: "Freedom"
    excerpt: "An app for nearby free events."
    btn_label: "Visit"
    btn_class: "btn--primary"
    github_url: "https://github.com/elliott-king/creepy-tracker"
  - image_path: assets/images/project-screenshots/drawful.png
    alt: "Drawful 1.5"
    title: "Drawful 1.5"
    excerpt: "A fun little clone of Drawful. You can play with up to six players."
    btn_label: "Visit"
    btn_class: "btn--primary"
    github_url: "https://github.com/elliott-king/drawful-1.5"

projects_row3:
  - image_path: assets/images/project-screenshots/kanye.png
    alt: "Screenshot of r/kanye analyzer"
    title: "R/Kanye Comment Analyzer"
    excerpt: "Use natural language processing to learn who is 'wavy' - according to [reddit.com/r/kanye](https://www.reddit.com/r/kanye)."
    btn_label: "Visit"
    btn_class: "btn--primary"
    github_url: "https://github.com/elliott-king/kanye_analyzer"
---

<link rel="stylesheet" href="/assets/styles/projects.css">

## Hi, I'm Elliott King

Data Science tickles the empirical part of my brain, but making projects that grow, walk, and run is my true passion.

I am currently volunteering with the [Astoria Digital](https://astoria.digital/) NYC-based aid organization. They provide web development and technical support for local volunteer organizations.

Reach out on [LinkedIn](https://www.linkedin.com/in/elliottwking/) or just [email me](mailto:elliottking93@gmail.com) if you are hiring for NYC or remote! I mostly work with Rails, Python, and JS, but I have dabbled in many technologies.

## Projects
{% include project_row id="projects_row1" %}
{% include project_row id="projects_row2" %}
{% include project_row id="projects_row3" %}