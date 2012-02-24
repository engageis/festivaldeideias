module ApplicationHelper

  def new_idea_button(css_class = nil)
    text = t('buttons.new_idea')
    if current_user
      link_to text, '#start', :rel => 'facebox', :class => css_class
    else
      link_to text, '#login', :rel => 'facebox', :class => css_class, :'data-return-url' => '#continue_idea' 
    end
  end

  # A url é o endereço que será 'curtido' no facebook e 'tweetado' no twitter
  # Se o objetivo é o endereço do site, passar 'request.host'
  def social_buttons(url, type = :horizontal)
    args = (type.to_sym == :horizontal) ? ['horizontal', 'button_count'] : ['vertical', 'box_count']

    render partial: 'shared/social_buttons',
           locals: { url: url,
                     orientation: type,
                     twitter_count: args[0],
                     facebook_count: args[1] }
  end

end
