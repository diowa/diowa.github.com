---
title: "Using RGeo with GEOS on Heroku"
description: "How to install Rgeo on Heroku, enabling support for GEOS library and optionally Proj4 coordinates"
layout: post
categories : [Heroku]
tagline: ''
tags : [RGeo, Heroku, GEOS, PROJ4]
author: tagliala
blog: true
---
{% include JB/setup.html %}

We had some struggles making RGeo work on Heroku with GEOS extension. Web lacks of updated information about this topic, the purpose of this post is to collect existing information and update them.

<!--more-->

### 1. Compiling GEOS (Optional)
If you are interested in building the GEOS library on Heroku by yourself, here it is a small guide. First of all, you should open a shell on Heroku via `heroku run bash`, then:

{% highlight bash %}
curl -O http://download.osgeo.org/geos/geos-3.5.0.tar.bz2
tar -xjvf geos-3.5.0.tar.bz2
cd geos-3.5.0
./configure --prefix=/app/.heroku/vendor
make && make install
tar -C /app/.heroku/vendor/ -czvf geos-3.5.0-heroku.tar.gz .
{% endhighlight %}

At this point, we have `geos-3.5.0-heroku.tar.gz` on our Heroku instance and we should move this file on a public location on the web. I'm not confident to share what we did because it is a very ugly way of moving files, but if you have suggestions on how to do this properly please leave a comment!

### 2. Set up the buildpack
We must tell Heroku to use multiple buildpacks and set `LD_LIBRARY_PATH` to `/app/lib`.

{% highlight bash %}
heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git LD_LIBRARY_PATH=/app/lib
{% endhighlight %}

At the root of your repository, add a `.buildpacks` file containing:

    https://github.com/peterkeen/heroku-buildpack-vendorbinaries.git
    https://github.com/diowa/heroku-buildpack-rgeo-prep.git
    https://github.com/heroku/heroku-buildpack-ruby.git

Add a `.vendor_urls` containing links to the compiled libraries. Note that the files below must be publicly accessible.

Working example:

    https://s3.amazonaws.com/diowa-buildpacks/geos-3.5.0-heroku.tar.gz

### 3. Deploy and check
Deploy to Heroku. You can check that everything is working by running `heroku run console`:

{% highlight ruby %}
> RGeo::Geos.supported?
=> true
{% endhighlight %}

Note that this guide could be applied to PROJ4 as well. Take a look at our [rgeo-prep buildpack](https://github.com/diowa/heroku-buildpack-rgeo-prep) if you need both libraries.

#### References

* [Run Vendored Binaries on Heroku](http://www.saintsjd.com/2014/05/12/run-vendored-binaries-on-heroku.html)
* [SpacialDB on Heroku](https://web.archive.org/web/20120417213149/http://devcenter.spacialdb.com/Heroku.html)
