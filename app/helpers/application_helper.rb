module ApplicationHelper

  def new_idea_button(text = nil)
    text ||= t('buttons.new_idea')
    if current_user
      link_to text, '#start', :rel => 'facebox', :class => 'button start'
    else
      link_to text, '#login', :rel => 'facebox', :class => 'button start', :'data-return-url' => '#continue_idea' 
    end
  end

end
