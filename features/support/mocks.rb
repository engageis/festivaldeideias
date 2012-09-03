class FakeTokboxSession
  def session_id
    "foo bar"
  end
end

Before do
  TOKBOX.stub(:create_session).and_return(FakeTokboxSession.new)
  Idea.any_instance.stub(:get_facebook_data).and_return([{"total_count" => 10, "commentsbox_count" => 2}])
end
