module Jekyll
  class TagIndex < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['tag'] = tag
      self.data['title'] = '#' + tag
    end
  end

  class TagsIndex < Page
    def initialize(site, base, dir, tags)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tags.html')
      self.data['tags'] = tags
    end
  end

  class TagGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag'
        dir = 'tag'
        site.tags.keys.each do |tag|
          write_tag_index(site, File.join(dir, tag), tag)
        end
      end
      write_tags_index(site, dir)
    end

    def write_tags_index(site, dir)
      tags = write_tagslist(site)
      index = TagsIndex.new(site, site.source, dir, tags)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end

    def write_tag_index(site, dir, tag)
      index = TagIndex.new(site, site.source, dir, tag)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end

    def write_tagslist(site)
      tags = Array.new
      site.posts.docs.each do |post|
        post.tags.each do |ltag|
          tags.push(ltag)
        end
      end

      return tags.uniq
    end
  end
end
