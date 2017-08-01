---
title: "Using RGeo with GEOS on Heroku"
description: "How to install Rgeo on Heroku, enabling support for GEOS library and optionally proj.4 coordinates"
layout: post
categories : [Heroku]
tagline: ''
tags : [RGeo, Heroku, GEOS, proj.4]
author: tagliala
blog: true
---
{% include JB/setup.html %}

We had some struggles making RGeo work on Heroku with GEOS extension. Web lacks of updated information about this topic, the purpose of this post is to collect existing information and update them.

<!--more-->

### Update! August, 1st 2017

Please take a look at the new article: [Use RGeo with GEOS on Heroku via apt-get]({% post_url 2017-08-01-using-rgeo-with-geos-on-heroku-with-apt-get %})

### Update! July, 1st 2016

`BUILDPACK_URL` was deprecated, so here it is a new approach.

### 1. Set up multiple buildpacks

We need to set `LD_LIBRARY_PATH` config variable to `/app/lib` and use the following buildpacks:

1. https://github.com/diowa/heroku-buildpack-rgeo-prep.git

   *Overwrites Heroku's default .bundle/config to set BUNDLE_BUILD__RGEO to Heroku's build directory*
2. https://github.com/peterkeen/heroku-buildpack-vendorbinaries.git

   *Allows us to vendor binaries into our project*
3. heroku/ruby

   *The official Heroku Buildpack for Ruby, Rack, and Rails apps*

We have a couple of way of achieving this:

#### Method 1: Using app.json

You need the following entries:

{% highlight json %}
{
  "...": "",
  "env": {
    "...": "",
    "LD_LIBRARY_PATH": "/app/lib",
    "...": ""
  },
  "...": "",
  "buildpacks": [
    {
      "url": "https://github.com/diowa/heroku-buildpack-rgeo-prep.git"
    },
    {
      "url": "https://github.com/peterkeen/heroku-buildpack-vendorbinaries.git"
    },
    {
      "url": "heroku/ruby"
    }
  ]
}
{% endhighlight %}

#### Method 2: Using the console

{% highlight bash %}
$ heroku buildpacks:set https://github.com/diowa/heroku-buildpack-rgeo-prep.git
$ heroku buildpacks:add https://github.com/peterkeen/heroku-buildpack-vendorbinaries.git
$ heroku buildpacks:add heroku/ruby
$ heroku config:set LD_LIBRARY_PATH=/app/lib
{% endhighlight %}


### 3. Provide URLs of vendor libraries

**Vendor Binaries** buildpack expects a `.vendor_urls` file in the root of the repository containing publicly accessible URLs to the libraries compiled at step 1.

Here it is a working example:

    https://s3.amazonaws.com/diowa-buildpacks/geos-3.6.1-heroku.tar.gz

Add this file to git and make sure it ends with a newline.

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

You can force recompiling in two ways:

1. Downgrade to a previous version of rgeo (0.5.3), deploy, rollback, deploy again;
2. Using the [heroku repo](https://github.com/heroku/heroku-repo) plugin, running `heroku repo:purge_cache -a appname` and deploying again (recommended).

### 5. Check

You can check that everything is working by running `heroku run console`:

{% highlight ruby %}
> RGeo::Geos.supported?
=> true
{% endhighlight %}

This guide could also be applied to proj.4. Take a look at our [rgeo-prep buildpack](https://github.com/diowa/heroku-buildpack-rgeo-prep) if you need both libraries.


### References

* [Run Vendored Binaries on Heroku](http://www.saintsjd.com/2014/05/12/run-vendored-binaries-on-heroku.html)
* [SpacialDB on Heroku](https://web.archive.org/web/20120417213149/http://devcenter.spacialdb.com/Heroku.html)
* [Buildpacks](https://devcenter.heroku.com/articles/buildpacks)
* [Using Multiple Buildpacks for an App](https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app)
* [app.json Schema](https://devcenter.heroku.com/articles/app-json-schema#buildpacks)
