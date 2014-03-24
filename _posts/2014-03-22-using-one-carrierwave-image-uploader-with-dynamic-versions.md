---
title: "Using one carrierwave image uploader with dynamic versions"
layout: post
categories : [Rails]
tagline: ''
tags : [carrierwave, dynamic versions, custom processing]
author: tagliala
---
{% include JB/setup %}

I was looking for a cleaner approach to manage models with different image versions. I came into [an awesome blog post](http://andreapavoni.com/blog/2012/3/using-one-carrierwave-image-uploader-with-different-sizes-on-several-models) by [Andrea Pavoni](http://andreapavoni.com/). I needed multiple, configurable processes so I extended that approach.

<!--more-->

I will go straight into the code because it is very simple and auto explicative.

#### slideshow_image.rb
{% highlight ruby %}
class SlideshowImage < ActiveRecord::Base

  IMAGE_VERSIONS = {
    slideshow: {
      resize_to_fill: [1200, 518],
      quality: 75
    },
    thumbnail: {
      resize_to_fill: [400, 172]
    },
    black_and_white: {
      resize_to_limit: [200, 200],
      desaturate: nil
    }
  }
  mount_uploader :image, ImageUploader

end
{% endhighlight %}

#### image_uploader.rb
{% highlight ruby %}
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  before :cache, :setup_available_versions

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process quality: 85
  process resize_to_limit: [2048, 2048]

  # better to always have a thumbnail version because it is used by Rails Admin
  %i(slideshow thumbnail black_and_white).each do |v|
    version v, if: :"has_#{v}_version?" do
      process dynamic_version: v
    end
  end

  def dynamic_version(version)
    model.class::IMAGE_VERSIONS[version].each do |method, args|
      self.send method, *args
    end
  end

  def method_missing(method, *args)
    return false if method.to_s.match(/has_(.*)_version\?/)
    super
  end

  # Note: this process requires a recent version of ImageMagick
  def desaturate
    manipulate! do |img|
      img.colorspace('Gray')
      img.brightness_contrast('20x0')
      img = yield(img) if block_given?
      img
    end
  end

  def quality(percentage)
    manipulate! do |img|
      img.strip
      img.quality(percentage.to_s)
      img = yield(img) if block_given?
      img
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  protected
  def setup_available_versions(file)
    model.class::IMAGE_VERSIONS.keys.each do |key|
      self.class_eval do
        define_method("has_#{key}_version?".to_sym) { |file| true }
      end
    end
  end
end

{% endhighlight %}

The only thing I really don't like is:

{% highlight ruby %}
%i(slideshow thumbnail black_and_white).each do |v|
  version v, if: :"has_#{v}_version?" do
    process dynamic_version: v
  end
end
{% endhighlight %}

I'm wondering if there is a better way of doing this, suggestions are appreciated!