# coding: utf-8
class IdeaMailer < ActionMailer::Base
  default from: "Festival de Ideias 2012 <fdi@festivaldeideias.org.br>"

  def new_colaboration_notification(idea)
    @idea = idea
    @user = idea.user
    
    mail(to: "#{@user.name} <#{@user.email}>", subject: "Sua ideia recebeu uma colaboração!") do |format|
      format.html
    end

  end

  def colaboration_was_accepted(idea)
    
  end

  def colaboration_was_rejected(idea)

  end

  def colaborated_ideas_has_changed(idea)

  end

end
