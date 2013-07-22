---
title: "Ruby2 Rails4 Bootstrap Heroku"
layout: post
categories : [Open Source]
tagline: ''
tags : [ruby2, rails4, twitter bootstrap, heroku]
author: tagliala
---
{% include JB/setup %}

Rails 4 brings many cool new features like <a href="https://github.com/rails/turbolinks/">Turbolinks</a> and <a href="https://github.com/rails/strong_parameters">Strong Parameters</a>. We already used these gems and as soon as Rails 4 has been released we created a starter app that includes Twitter Bootstrap, Font Awesome and some other defaults like <a href="http://rspec.info">Rspec</a> and <a href="http://haml.info/">HAML</a>.

<!--more-->

In order to use it all you have to do is:

{% highlight bash %}
$ git clone https://github.com/diowa/ruby2-rails4-bootstrap-heroku.git
{% endhighlight %}

If you want to deploy it on Heroku:

{% highlight bash %}
$ cd ruby2-rails4-bootstrap-heroku
$ heroku create
$ git push heroku master
{% endhighlight %}
