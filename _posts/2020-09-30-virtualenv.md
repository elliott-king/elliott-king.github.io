---
layout: single
title: "Python Virtual Environments and Beyond"
date: 2020-09-30 09:00:00 -0000
categories: python heroku
excerpt: An overview of Python virtual environments.
---

When I was first learning Python, the concept of virtual environments seemed unnecessary to me. Why would I bother keeping track of a different set of libraries within my current directory? What is wrong with the global ones? It wasn't until I became a more mature programmer that I realized the usefulness.

After a few years of writing python, you may have multiple different versions of python on your system. Each version may have different libraries, and when you install a new library, it may have different requirements to other things. This eventually can get very confusing, but it can still be handled. Only recently did I realize the most important aspect of them: deployments. If you wish to deploy your application to AWS, Heroku, or just upload the library to Github, the virtualenv will mirror the environments on these remote locations.

A python virtual environment is a new python environment that is set up within a directory. It starts with no extra libraries, and new libraries will not be installed globally. It is self-contained.

# Comparison: JS and Ruby

I have a much better understanding of venvs after learning Node JS. For a Node project, you create a file called `package.json`, and you include a list of the application dependencies. Node's package manager, npm, then installs these dependencies to a directory called `node_modules`. Everything is self-contained, and when you run the application, it does not depend on anything external. You can then package it up and send it to any server, run `npm install`, and your application is good to go.

Ruby has a similar setup. You list the necessary packages in your `Gemfile`, and this is what Ruby's package manager refers to when installing your application on another location. Ruby's `bundler` does not use a local directory (unless you are running in deployment mode), but it will not allow you to use system packages unless listed in the `Gemfile`. It has a more hybrid approach.

# Setting Up a Virtual Environment

You can create a python venv for your current directory using python `venv`:

```bash
python -m venv venv/
```

Where `venv/` is the directory that your virtual environment will be held in. You can use a different directory name, but I do not suggest it. Make sure `venv/` is included in your `.gitignore` file. The default [python gitignore](https://github.com/github/gitignore/blob/master/Python.gitignore) already has this.

You then initialize it with:

```bash
source venv/bin/activate
```

My zsh shell will show me when I have an active venv (courtesy of [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)):

![venv shown in zsh](/assets/images/venv/py_venv.png)

Alternatively, you can see what python environment you are currently on:

```bash
pip -V
```

Finally, you can exit the venv simply with:

```bash
deactivate
```

While a venv is active, running `pip install` will only install libraries within the current environment.

# Requirements

A `requirements.txt` file can be considered a parallel to Node JS' `package.json`. It should list all required packages for an application. This file is used by many SAAS deployments. For example, Heroku needs the file to know what to install on its machines. An example file might look like this:

![example requirements.txt](/assets/images/venv/py_requirements.png)

Python already is set up to support a requirements file. If you are in a venv, you can write your currently installed libraries:

```bash
pip freeze > requirements.txt
```

If you are installing requirements for an existing project, you can use:

```bash
pip install -r requirements.txt
```