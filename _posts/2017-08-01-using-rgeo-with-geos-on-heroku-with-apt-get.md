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

### Update! August, 13th 2019

Add a note about `LD_LIBRARY_PATH` variable and the Rake Task

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
$ heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-apt
{% endhighlight %}

### 3. Unset LD_LIBRARY_PATH

If you have previously set the `LD_LIBRARY_PATH` variable, please unset that

{% highlight bash %}
$ heroku config:unset LD_LIBRARY_PATH
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

### 6. Optional Release task

You may be interested in checking that RGeo properly supports GEOS at deploy
time. If something goes wrong, the deploy will fail.

Add a `release` entry to your `Procfile`:

{% highlight bash %}
release: bundle exec rails rgeo_supports_geos
{% endhighlight %}

Create a rake task:

{% highlight ruby %}
# frozen_string_literal: true

desc 'Check that RGeo supports GEOS'
task :rgeo_supports_geos do
  abort 'Error: RGeo does not support GEOS, application cannot start.' unless RGeo::Geos.supported?
end
{% endhighlight %}

### Notes

An APT package may not be up to date with the latest version of the library it includes. In the before example, you will get GEOS 3.5.0, but (at the moment I'm writing) version 3.6.2 is out.

If you need newer versions of your libraries, you could use the following approach: [Compile libraries on Heroku with Vesuvius]({% post_url 2017-08-01-compile-libraries-on-heroku-with-vesuvius %}).

### References

* [Buildpacks](https://devcenter.heroku.com/articles/buildpacks)
* [heroku-buildpack-apt](https://elements.heroku.com/buildpacks/heroku/heroku-buildpack-apt)
* [app.json Schema](https://devcenter.heroku.com/articles/app-json-schema#buildpacks)
* [Release Phase](https://devcenter.heroku.com/articles/release-phase)
