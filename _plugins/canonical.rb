module Canonical
  def canonical(url)
    url.gsub /\/index\.html\Z/, '/'
  end
end

Liquid::Template.register_filter(Canonical)
