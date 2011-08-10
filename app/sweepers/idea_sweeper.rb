class IdeaSweeper < ActionController::Caching::Sweeper
  observe Idea

  def before_save(idea)
    expire_cache_for(idea)
  end

  def after_destroy(idea)
    expire_cache_for(idea)
  end

  def expire_cache_for(idea)
    expire_page(:controller => 'ideas', :action => 'index')
    idea.expire_doc_cache
  end
end