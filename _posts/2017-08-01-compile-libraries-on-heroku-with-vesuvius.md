---
title: "Compile libraries on Heroku with Vesuvius"
description: "How to build libraries on Heroku with Vesuvius, a Vulcan replacement"
layout: post
categories : [Heroku]
tagline: ''
tags : [Heroku, GEOS, proj.4, build libraries, build binaries, heroku-16, vesuvius]
author: tagliala
blog: true
---
{% include JB/setup.html %}

It has been a long time since [Vulcan](https://github.com/heroku/vulcan) has been deprecated. Now, gcc [is no longer available at runtime on heroku-16](https://devcenter.heroku.com/articles/stack-packages) so Vesuvius comes in help.

<!--more-->

## Why Vesuvius?

[Vulcan](https://github.com/heroku/vulcan) has been deprecated and GCC is only available [at build time](https://devcenter.heroku.com/articles/stack-packages) on `heroku-16` stack.

Even with `heroku run bash`, compiling stuff on Heroku was painful, time consuming, and you needed a third-party cloud storage to move your compiled library in order to download it.

With [**Vesuvius**](https://github.com/tagliala/vesuvius), this is no longer the case. During the deploy, **Vesuvius** will run all scripts located in `/scripts/libraries` and will move output files to a public directory.

It comes with [proj.4](http://proj4.org/index.html) and [GEOS](https://trac.osgeo.org/geos/) as examples.

## Automatic Setup

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/tagliala/vesuvius/tree/master)

## Manual Setup

1. Clone the repo at [https://github.com/tagliala/vesuvius](https://github.com/tagliala/vesuvius)
2. Create a new Heroku application
3. Set your buildpack to Heroku's default Ruby buildpack
{% highlight sh %}
heroku buildpacks:set heroku/ruby
{% endhighlight %}
4. Append the buildpack-ruby-rake-deploy-tasks to your buildpack list
{% highlight sh %}
heroku buildpacks:add https://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks
{% endhighlight %}
5. Configure DEPLOY_TASK environment variable
{% highlight sh %}
heroku config:set DEPLOY_TASKS=build_libraries
{% endhighlight %}

Deploy and navigate to your application's root path.

## Example script

All you need to do is create a bash script to compile your library.

This is an example for the GEOS library:

{% highlight sh %}
#!/bin/bash

LIBRARY_VERSION=3.6.2

curl -O http://download.osgeo.org/geos/geos-${LIBRARY_VERSION}.tar.bz2 \
  && tar -xjvf geos-${LIBRARY_VERSION}.tar.bz2 \
  && cd geos-${LIBRARY_VERSION} \
  && ./configure --prefix=${HEROKU_VENDOR_DIR} \
  && make && make install \
  && tar -C ${HEROKU_VENDOR_DIR} -czvf ${TARGET_DIR}/geos-${LIBRARY_VERSION}-heroku.tar.gz .
{% endhighlight %}

### References

* [Vesuvius](https://github.com/tagliala/vesuvius)
* [Run Vendored Binaries on Heroku](http://www.saintsjd.com/2014/05/12/run-vendored-binaries-on-heroku.html)
* [Ubuntu Packages on Heroku Stacks](https://devcenter.heroku.com/articles/stack-packages)
