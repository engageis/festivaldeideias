module ApplicationHelper

  def new_idea_button(text = nil)
    text ||= t('buttons.new_idea')
    if current_user
      link_to text, '#start', :rel => 'facebox', :class => 'button start'
    else
      link_to text, '#login', :rel => 'facebox', :class => 'button start', :'data-return-url' => '#continue_idea' 
    end
  end

  def social_buttons(url, type = :horizontal)
    args = (type.to_sym == :horizontal) ? ['horizontal', 'button_count'] : ['vertical', 'box_count']
    render partial: 'shared/social_buttons', locals: { url: url,
                                                       orientation: type,
                                                       twitter_count: args[0],
                                                       facebook_count: args[1] }
  end

end
