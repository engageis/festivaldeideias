# coding: utf-8
class CollaborationsController < ApplicationController
  def show
    @collaboration = Collaboration.find(params[:id])
  end

  def create
    @collaboration = Collaboration.new(params[:collaboration])
    @collaboration.user = current_user
    if @collaboration.save
      redirect_to idea_path(@collaboration.idea_id)
    else
      redirect_to idea_path(@collaboration.idea_id), notice: "Não foi possível publicar sua colaboração"
    end
  end

  def destroy
    @collaboration = Collaboration.find(params[:id])
    idea = @collaboration.idea
    @collaboration.destroy if @collaboration.user == current_user
    redirect_to idea
  end
end