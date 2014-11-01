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

I was looking for a cleaner approach to manage models with different image versions. I came into [this awesome blog post](http://andreapavoni.com/blog/2012/3/using-one-carrierwave-image-uploader-with-different-sizes-on-several-models) by [Andrea Pavoni](http://andreapavoni.com/). I needed multiple, configurable processes so I extended and updated his excellent work.

<!--more-->

### Update! November, 1st 2014
Improved the code with an initializer. This fixes an edge case with Rails Admin (versions are not created when validations fails). Now we will not pollute models with image versions and we can use the same versions for multiple models but there is a little bit of separation as a drawback.

We also improved the image uploader in order to provide progressive jpegs.


#### image_versions_.rb (initializer)
{% highlight ruby %}
APP_IMAGE_VERSIONS = {
  asset: {
    fill_1200x518: {
      resize_to_fill: [1200, 518]
    },
    black_and_white: {
      resize_to_limit: [200, 200],
      desaturate: nil
    }
  },
  gallery: {
    fill_800x600: {
      resize_to_fill: [800, 600]
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

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_limit: [2048, 2048]
  process :optimize

  # better to always have a thumbnail version because it is used by Rails Admin
  version :thumbnail do
    process resize_to_fit: [300, 300]
  end

  APP_ALL_IMAGE_VERSIONS.each do |v|
    version v, if: -> (uploader, opts) { uploader.model.class::IMAGE_VERSIONS.has_key?(opts[:version]) } do
      process dynamic_version: v
      process :optimize
    end
  end

  def dynamic_version(version)
    model.class::IMAGE_VERSIONS[version].each do |method, args|
      self.send method, *args
    end
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
end

{% endhighlight %}

Suggestions to improve this are always appreciated!
