desc "This task migrates all comments from Facebook to Collaboration model"

task :migrate_all_comments => :environment do
  Idea.migrate_all_comments!
end

