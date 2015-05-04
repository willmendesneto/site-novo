
module Jekyll
  class CategorizeLoader < Generator
    safe true

    def generate(site)
      @all_articles = site.posts
      @newest_post = @all_articles.sort { |a, b| b <=> a }[0..300]
      cover = find('cover').first
      tv_mst = find('tv').slice(0,5)
      newspapers = find('newspaper')

      campaigns = find('campaign')
      carousel = @newest_post.slice!(0,5) # the first five posts goes on carousel

      special_stories = find('special-stories', 'label', 2, carousel)
      recent = @newest_post.delete_at(0) # the sixth post goes on recent

      if campaigns.size < 1
        featured_news = find('featured-news').slice(0,3)
      else
        featured_news = find('featured-news').slice(0,2)
      end


      articles = find 'articles', 'label'
      interviews = find 'interviews', 'label'

      musicoteca  = find 'musicoteca', 'section', 50
      musicoteca_videos = find('tv','section', 3).select{ |v| v.data['sector'] == 'culture'  }
      musicoteca_albuns = musicoteca.select{ |m| m.data['type'] == 'album' }
      musicoteca_partners = musicoteca.select{ |m| m.data['type'] == 'partner' }
      site.config['musicoteca'] = {}
      site.config['musicoteca']['videos'] = musicoteca_videos
      site.config['musicoteca']['albuns'] = musicoteca_albuns
      site.config['musicoteca']['partners'] = musicoteca_partners

      site.config['cover'] = cover
      site.config['articles'] = articles
      site.config['carousel'] = carousel
      site.config['recent'] = recent
      site.config['featured_news'] = featured_news
      site.config['interviews'] = interviews
      site.config['tv_mst'] = tv_mst
      site.config['special_stories'] = special_stories
      site.config['campaigns'] = campaigns
      site.config['newspaper'] = newspapers.first
      site.config['others'] = @newest_post

    end

    def find value, field = 'section', minimum = 0, except = []
      result = filter_with_except(value, field, @newest_post, except)
      if result.size < minimum
        result = filter_with_except(value, field, @all_articles, except)
      end

      result.sort! { |a, b| b <=> a }
      @newest_post = @newest_post - result
      result
    end

    def filter_with_except value, field, collection, except = []
      collection.select do |post|
        field_value = post.data[field] == value
        item_id = except.select do |item|
          item.id == post.id
        end

        field_value && item_id.size == 0
      end
    end
  end

end
