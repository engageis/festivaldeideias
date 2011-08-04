class IdeaSweeper < ActionController::Caching::Sweeper
  observe Idea

  def after_save(idea)
    expire_cache_for(idea)
  end

  def expire_cache_for(idea)
    expire_fragment(:controller => 'ideas', :action => 'index', :action_suffix => 'ideas_listing')
    expire_page(:controller => 'ideas', :action => 'index')
  end
end