class Idea < ActiveRecord::Base

  validates_presence_of :title, :description, :category
  belongs_to :user
  belongs_to :category, :class_name => "IdeaCategory", :foreign_key => :category_id
  belongs_to :parent, :class_name => :Idea, :foreign_key => :parent_id

  scope :featured,  where(:featured => true).order('position DESC')
  scope :latest,    order('updated_at DESC')
  scope :recent,    order('created_at DESC')


  def to_param
    "#{id}-#{title.parameterize}"
  end

end
