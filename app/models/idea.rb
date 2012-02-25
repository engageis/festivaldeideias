class Idea < ActiveRecord::Base
  include AutoHtml
  include ActiveRecord::SpawnMethods
  include Rails.application.routes.url_helpers

  validates_presence_of :title, :description, :category, :user

  belongs_to :user
  belongs_to :category, :class_name => "IdeaCategory", :foreign_key => :category_id
  belongs_to :parent  , :class_name => "Idea", :foreign_key => :parent_id

  has_many :colaborations, :class_name => "Idea", :foreign_key => :parent_id

  # Scope for colaborations
  scope :not_accepted, where(:accepted => false).order('created_at DESC')

  scope :featured,  where(:featured => true, :parent_id => nil).order('position DESC')
  scope :latest,    where(:parent_id => nil).order('updated_at DESC')
  scope :recent,    where(:parent_id => nil).order('created_at DESC')
  scope :popular,   where(:parent_id => nil).order('likes DESC')


  def self.create_colaboration(params = {})
    if params.has_key? :parent_id
      Idea.create(params)
    end
  end

  # Modify the json response
  def as_json(options={})
    {
      :id => id,
      :title => title,
      :headline => headline,
      :category => category,
      :user => user.id,
      :description => description,
      :description_html => description_html,
      :likes => likes,
      :colaborations => colaborations.count,
      :url => category_idea_path(category, self)
    }
  end

  # This affects links
  def to_param
    "#{id}-#{title.parameterize}"
  end

  # Convert the description text
  def description_html
    convert_html description
  end


  # Use AutoHtml gem to convert texts
  def convert_html(text)
    auto_html text do
      html_escape :map => {
        '&' => '&amp;',
        '>' => '&gt;',
        '<' => '&lt;',
        '"' => '"'
      }
      image
      youtube :width => 510, :height => 332
      vimeo :width => 510, :height => 332
      link :target => :_blank
      redcarpet :target => :_blank
    end
  end
end
