---
title: "Using one carrierwave image uploader with dynamic versions"
description: How to manage models with different image versions with only one image uploader
layout: post
categories : [Rails]
tagline: ''
tags : [carrierwave, dynamic image versions, custom image processing]
author: tagliala
blog: true
---
{% include JB/setup.html %}

I was looking for a cleaner approach to manage models with different image versions. I came into [this awesome blog post](http://andreapavoni.com/blog/2012/3/using-one-carrierwave-image-uploader-with-different-sizes-on-several-models) by [Andrea Pavoni](http://andreapavoni.com/). I needed multiple, configurable processes so I extended and updated his work.

<!--more-->

### Update! October, 9th 2014
Improved the code with an initializer. In this way we will not pollute models with image versions, we can use the same versions for multiple models but there is a little bit of separation.

We also improved the image uploader in order to provide progressive jpegs.


#### image_versions_.rb (initializer)
{% highlight ruby %}
# better to always have a thumbnail version because it is used by Rails Admin

APP_IMAGE_VERSIONS = {
  asset: {
    fill_1200x518: {
      resize_to_fill: [1200, 518],
      quality: 75
    },
    black_and_white: {
      resize_to_limit: [200, 200],
      desaturate: nil
    },
    thumbnail: {
      resize_to_fill: [400, 172]
    }
  },
  gallery: {
    fill_800x600: {
      resize_to_fill: [800, 600]
    },
    thumbnail: {
      resize_to_fit: [300, 300]
    }
  }
}

APP_ALL_IMAGE_VERSIONS = APP_IMAGE_VERSIONS.map{ |k,v| v.keys }.flatten.uniq
{% endhighlight %}

#### slideshow_image.rb
{% highlight ruby %}
class SlideshowImage < ActiveRecord::Base

  IMAGE_VERSIONS = APP_IMAGE_VERSIONS[:asset]
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

  process resize_to_limit: [2048, 2048]
  process :optimize

  APP_ALL_IMAGE_VERSIONS.each do |v|
    version v, if: :"has_#{v}_version?" do
      process dynamic_version: v
      process :optimize
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

  def optimize
    manipulate! do |img|
      img.combine_options do |c|
        c.strip
        c.quality '85'
        c.depth '8'
        c.interlace 'Line'
      end
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

Suggestions to improve this are always appreciated!
