require 'active_support/core_ext/array/conversions'
require 'time'

set :haml, remove_whitespace: true

activate :directory_indexes

page '/googlee90f4c89e6c3d418.html', directory_index: false

activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
end

# Build-specific configuration
configure :build do
  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  activate :gzip
end

ready do
  [
    ['index', ''],
    ['movies/curse-of-the-demon-1957', 'reviews/curse-of-the-demon-1958/'],
    ['movies/riders-of-destiny-1933', 'reviews/riders-of-destiny-1933/'],
    ['movies/curse-of-the-crimson-altar-1968', 'reviews/curse-of-the-crimson-altar-1968/'],
    ['movies/the-road-to-singapore-1931', 'reviews/the-road-to-singapore-1931/'],
    ['movies/black-legion-1937', 'reviews/black-legion-1937/'],
    ['movies/straw-dogs-1971', 'reviews/straw-dogs-1971/'],
    ['movies/sagebrush-trail-1933', 'reviews/sagebrush-trail-1933/'],
    ['movies/men-are-such-fools-1938', 'reviews/men-are-such-fools-1938/'],
    ['movies/the-ghoul-1933', 'reviews/the-ghoul-1933/']
  ].each do |redirect|
    old_slug, new_slug = redirect
    proxy("#{old_slug}.html", 'redirect.html', layout: false, locals: { new_slug: new_slug }, ignore: true)
  end
end

#
# Opened to fix build deleting the .git directory.
#
class Middleman::Cli::BuildAction < ::Thor::Actions::EmptyDirectory # rubocop:disable Style/ClassAndModuleChildren
  # Remove files which were not built in this cycle
  # @return [void]
  def clean!
    @to_clean.each do |f|
      base.remove_file(f, force: true) unless f =~ /\.git/
    end

    ::Middleman::Util.glob_directory(@build_dir.join('**', '*'))
                     .select { |d| File.directory?(d) }
                     .each do |d|
      base.remove_file d, force: true if directory_empty? d
    end
  end
end