module PostMore
  def post_more(input, url = '', text = '&hellip;')
    if input.include? "<!--more-->"
      input.split("<!--more-->").first #+ "<p class='more'><a href='#{url}'>#{text}</a></p>"
    else
      input
    end
  end
end

Liquid::Template.register_filter(PostMore)
