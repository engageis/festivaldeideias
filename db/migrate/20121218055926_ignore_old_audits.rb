class IgnoreOldAudits < ActiveRecord::Migration
  def up
    execute("UPDATE audits SET timeline_type = 'ignore' WHERE timeline_type = 'collaboration_sent' OR timeline_type = 'collaboration_accepted' OR timeline_type = 'collaboration_rejected' OR  timeline_type = 'idea_ramified'")
  end

  def down
    # Sorry
  end
end
