---
title: Add likes to your Mongoid models
layout: post
categories : [Open Source, Rubygems]
tagline: ''
tags : [ruby, mongoid, open source]
author: cesidio
blog: true
---
{% include JB/setup %}

We needed a way to add likes to stories for <a href="http://beta.minstrels.com">Minstrels</a>. We started looking for gems that provide this functionality and we found <a href="http://github.com/tombell/mongoid-voteable">tombell/mongoid-voteable</a>, that does a little more by providing a voting system to mongoid models. So we decided to fork this gem and focus only on likes. Today we gave it back to the open source community.

<!--more-->

### Installation

add the gem to your `Gemfile`

{% highlight bash %}
gem 'mongoid-likeable'
{% endhighlight %}


### Usage

Include the `Mongoid::Likeable` module to the models you want to like.

{% highlight ruby %}
class Story
  include Mongoid::Document
  include Mongoid::Likeable

  # ...
end
{% endhighlight %}

You can like a story by simply using the `like` method on the model.

{% highlight ruby %}
@story = Story.first
@user = User.first

@story.like @user
@story.unlike @user
{% endhighlight %}

There is also a method to check if a user liked a model.

{% highlight ruby %}
@story.liked? @user # true if the user has already liked this
{% endhighlight %}
Likes are stored in a field called `likes`, so you can sort models by like count.

**Note**: if your users are not stored in a Mongo collection or the ID field is
not called `_id`, you can still pass the ID in as the second parameter instead.

{% highlight ruby %}
@story.like @user.id

@story.liked? @user.id
{% endhighlight %}
