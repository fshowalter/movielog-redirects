require 'active_support/core_ext/array/conversions'
require 'time'

set :haml, remove_whitespace: true

activate :directory_indexes

activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
  deploy.clean = true
end

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  activate :gzip
end

ready do
  [
    ['movies/curse-of-the-demon-1957', 'reviews/curse-of-the-demon-1958/'],
    ['movies/riders-of-destiny-1933', 'reviews/riders-of-destiny-1933/'],
    ['movies/curse-of-the-crimson-altar-1968', 'reviews/curse-of-the-crimson-altar-1968/'],
    ['movies/the-road-to-singapore-1931', 'reviews/the-road-to-singapore-1931/']
  ].each do |redirect|
    old_slug, new_slug = redirect
    proxy("#{old_slug}.html", 'redirect.html', layout: false, locals: { new_slug: new_slug }, ignore: true)
  end
end
