class Idea < ActiveRecord::Base
  
  include Rails.application.routes.url_helpers
  
  belongs_to :site
  belongs_to :user
  belongs_to :category
  belongs_to :template
  belongs_to :parent, :class_name => 'Idea', :foreign_key => :parent_id
  
  validates_presence_of :site, :user, :category, :template, :title, :headline
  validates_length_of :headline, :maximum => 140

  scope :featured, where(:featured => true).order('"order"')
  scope :not_featured, where(:featured => false)
  scope :recommended, where(:recommended => true).order("created_at DESC")
  scope :popular, order("likes DESC")
  scope :recent, order("created_at DESC")

  before_save :set_was_new_record
  def set_was_new_record
    @was_a_new_record = new_record?
    return true
  end

  after_save :save_document
  def save_document
    begin
      if @was_a_new_record
        RestClient.post "#{self.url}", document.to_json
      else
        RestClient.put "#{self.url}/#{self.id}", document.to_json
      end
    rescue
    end
  end
  
  after_find :load_document
  def load_document
    begin
      self.document = JSON.parse(RestClient.get("#{self.url}/#{self.id}"))
    rescue
    end
  end

  after_destroy :delete_document
  def delete_document
    begin
      RestClient.delete "#{self.url}/#{self.id}"
    rescue
    end
  end    

  def self.url
    @@url ||= Configuration.find_by_name('git_document_db_url').value
  end
  def url
    self.class.url
  end
  
  def document
    @document ||= {}
    @document.merge! "id" => self.id, "title" => self.title, "headline" => self.headline
  end
  
  def document=(new_document)
    @document = new_document.merge "id" => self.id, "title" => self.title, "headline" => self.headline
  end
  
  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  def as_json(options={})
    {
      :id => id,
      :title => title,
      :headline => headline,
      :category => category,
      :user => user,
      :document => document,
      :url => idea_path(self)
    }
  end
  
end
