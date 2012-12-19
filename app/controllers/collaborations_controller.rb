# coding: utf-8
class CollaborationsController < ApplicationController
  
  inherit_resources

  actions :show, :create

  def create
    @collaboration = Collaboration.new(params[:collaboration])
    @collaboration.user = current_user
    create! do |success, failure|
      success.html { redirect_to category_idea_path(resource.idea.category, resource.idea), notice: "Sua colaboração foi enviada com sucesso :D" }
      failure.html { redirect_to category_idea_path(resource.idea.category, resource.idea), alert: "Não foi possível publicar sua colaboração" }
    end
  end
end