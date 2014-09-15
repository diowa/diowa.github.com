---
title: "Nitrous.IO: Rails development inside your browser"
description: "Nitrous.IO: Rails development inside your browser"
layout: post
categories : [Rails]
tagline: ''
tags : [rails, ruby, Nitrous.IO, web development]
author: cesidio
blog: true
---
{% include JB/setup.html %}

Years ago I was amused by Heroku giving the possibility to do development inside a web IDE. That product was called [Heroku Garden](http://web.archive.org/web/20090121092638/http://herokugarden.com/) but it was discontinued and Heroku focused only on easing the deployment of web apps.

<!--more-->

Nowadays deployment is pretty much automated while development still happens on a local machine where you need to install all the relevant software like web servers, database servers, SDKs, etc. You have to do this only once per machine, but it is a very time consuming process and if for some reasons you don't have your machine with you, you are not able to work on your projects, even though your code is probably already hosted on GitHub and accessible from everywhere.

Nitrous.IO tries to fix that and gives you the ability to do web development inside a browser from any computer connected to the Internet. In this blog post I will show how to set up a Nitrous.IO box to work on [Ruby2 Rails4 Bootstrap Heroku Starter App](https://github.com/diowa/ruby2-rails4-bootstrap-heroku).


### 1. Create a box

The first thing to do is to [create a box on Nitrous.IO](https://www.nitrous.io/join/rAkwYY7Gqog) (note: this is a referral link. [This one is a link without referral](https://www.nitrous.io/join)). You need at least 190 N2O to get 512MB of memory (the minimum amount of memory required to run our starter app). When you sign up at Nitrous.IO you get 150 N2O. To get extra N2O you can either pay or [link your social accounts and invite colleagues to try the service](https://www.nitrous.io/app#/n2o/bonus).


### 2. Set up SSH, GitHub and Heroku

Now you have to follow these steps:
* [Create a new SSH key](http://help.nitrous.io/ssh-add/)
* [Link your GitHub account](http://help.nitrous.io/github-add-key/)
* [Integrate with Heroku](http://help.nitrous.io/heroku/)


### 3. Set up databases

[Create two free dev plan databases with Heroku Postgres](https://postgres.heroku.com/), one for development and one for testing.

The Rails4 starter app we are going to use has a [database.yml](https://github.com/diowa/ruby2-rails4-bootstrap-heroku/blob/master/config/database.yml) file configured to work on Nitrous.IO, TravisCI and a local machine (comments and pull requests are welcome).

Once you create these 2 databases, open the web IDE for your Nitrous.IO box and add the following lines to `.bashrc` file in your home (Tip: if you cannot see that file from the editor is probably because you have to enable the option to show hidden files):

{% highlight bash %}
export STARTER_APP_DEV_DB_DATABASE=YOUR_DEV_DB_DATABASE
export STARTER_APP_DEV_DB_USER=YOUR_DEV_DB_USER
export STARTER_APP_DEV_DB_PASSWORD=YOUR_DEV_DB_PASSWORD
export STARTER_APP_DEV_DB_HOST=YOUR_DEV_DB_HOST
export STARTER_APP_DEV_DB_PORT=YOUR_DEV_DB_PORT

export STARTER_APP_TEST_DB_DATABASE=YOUR_TEST_DB_DATABASE
export STARTER_APP_TEST_DB_USER=YOUR_TEST_DB_USER
export STARTER_APP_TEST_DB_PASSWORD=YOUR_TEST_DB_PASSWORD
export STARTER_APP_TEST_DB_HOST=YOUR_TEST_DB_HOST
export STARTER_APP_TEST_DB_PORT=YOUR_TEST_DB_PORT
{% endhighlight %}


### 4. Clone the starter app

Use the standard git commands to clone Ruby2 Rails4 Bootstrap Starter App inside your Nitrous.IO box shell:
{% highlight bash %}
cd workspace
git clone https://github.com/diowa/ruby2-rails4-bootstrap-heroku.git
cd ruby2-rails4-bootstrap-heroku
bundle
{% endhighlight %}

Test that specs pass:
{% highlight bash %}
rspec
{% endhighlight %}

Start the server and check that everything works from the Preview menu item (default port is 3000).
{% highlight bash %}
rails s
{% endhighlight %}


### 5. Deploy on Heroku

{% highlight bash %}
heroku create
git push heroku master
{% endhighlight %}


### Considerations

Being able to work on your projects without carrying your machine is a great freedom, but it comes at a price: the web ide is not that productive. Simple things like a global search and replace require you to master the command line. I certainly miss TextMate, [git-flow](http://nvie.com/posts/a-successful-git-branching-model/) or something like GitX. A viable compromise is to install [Nitrous.IO for Mac](https://www.nitrous.io/mac) if you work on a Mac, so that you can just install your favorite text editor and git GUI.
