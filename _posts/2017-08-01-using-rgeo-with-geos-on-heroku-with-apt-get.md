---
title: "Using RGeo with GEOS on Heroku with apt-get"
description: "How to install Rgeo on Heroku, enabling support for GEOS and proj.4 coordinates"
layout: post
categories : [Heroku]
tagline: ''
tags : [RGeo, Heroku, GEOS, proj.4, apt-get]
author: tagliala
blog: true
---
{% include JB/setup.html %}

Here it is a new, super-easy approach to use Rgeo with GEOS on Heroku, by using the amazing `heroku-buildpack-apt` buildpack.

<!--more-->

### 1. Add Aptfile

At the root of your repository, add a file called `Aptfile` with the following content:

```
libproj-dev
libgeos-dev
```

Make sure it ends with a newline.

### 2. Add the heroku-buildpack-apt buildpack

#### Method 1: Using app.json

You need to add the following entries:

{% highlight json %}
  "buildpacks": [
    {
      "url": "https://github.com/heroku/heroku-buildpack-apt"
    },
    {
      "url": "heroku/ruby"
    }
  ]
{% endhighlight %}

#### Method 2: Using the console

{% highlight bash %}
$ heroku buildpacks:set https://github.com/heroku/heroku-buildpack-apt
$ heroku buildpacks:add heroku/ruby
{% endhighlight %}


### 4. Deploy

Deploy to Heroku. Please note that if you have already installed rgeo, you need
to recompile the gem.

Check the deploy log:

{% highlight bash %}
# bad
remote:        Using rgeo 0.6.0

# good
remote:        Installing rgeo 0.6.0 with native extensions
{% endhighlight %}

You can force recompiling by using the [heroku repo](https://github.com/heroku/heroku-repo) plugin, running `heroku repo:purge_cache -a appname` and deploying again.

### 5. Check

You can check that everything is working by running `heroku run console`:

{% highlight ruby %}
> RGeo::Geos.supported?
=> true
{% endhighlight %}

### References

* [Buildpacks](https://devcenter.heroku.com/articles/buildpacks)
* [heroku-buildpack-apt](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-apt)
* [app.json Schema](https://devcenter.heroku.com/articles/app-json-schema#buildpacks)
