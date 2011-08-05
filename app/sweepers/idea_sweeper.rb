class IdeaSweeper < ActionController::Caching::Sweeper
  observe Idea

  def after_save(idea)
    expire_cache_for(idea)
  end
  
  def after_destroy(idea)
    expire_cache_for(idea)
  end

  def expire_cache_for(idea)
    doc_cache_path = "#{RAILS_ROOT}/tmp/docs_cache/#{idea.id}.json"
    FileUtils.rm(doc_cache_path) if File.exists?(doc_cache_path)
    expire_fragment(:controller => 'ideas', :action => 'index', :action_suffix => 'ideas_listing')
    expire_page(:controller => 'ideas', :action => 'index')
  end
end