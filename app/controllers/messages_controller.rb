#coding: utf-8
class MessagesController < ApplicationController
  inherit_resources
  belongs_to :idea

  def create
    @message = Message.create!(params[:message])
  end
end
