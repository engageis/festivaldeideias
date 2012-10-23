class Blog
  class << self
    def fetch_last_posts
      Rails.cache.fetch('blog_posts', expires_in: 20.minutes) do
        begin
          feed = Feedzirra::Feed.fetch_and_parse("http://blog.festivaldeideias.org.br/feed/")
          feed.entries
        rescue
          []
        end
      end
    end
  end
end