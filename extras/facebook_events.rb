# coding: utf-8

require 'koala'
require 'json'

=begin
  Meu id: 100002129060701
  Id do Festival de ideias: 211024602327337
  Id do Festival teste: 191020401004722
=end

class FacebookEvents
  FB = Koala::Facebook
  @@queries = {
    "query1" => "SELECT eid FROM event_member WHERE uid = 211024602327337",
    "query2" => "SELECT eid, name, start_time, location FROM event WHERE eid IN ( SELECT eid FROM #query1 )"
  }
  oauth = FB::OAuth.new(CONFIG['facebook_app_id'], CONFIG['facebook_secret_key'], CONFIG['callback_url'])
  token = oauth.get_app_access_token
  raise token
  @@rest = FB::API.new(token)

  def self.get_events
    #now = Time.now
    #fql = @@rest.fql_multiquery(@@queries)
    #JSON.parse(fql['query2'].to_json)
  end
end
