# coding: utf-8
ActiveAdmin.register Idea do
  menu :label => "Curação de ideias"

  #
  # Initial Implementation of featured / position ajax submition
  #
  index do

    # Testing the featured? implementation
    # This will change the boolean column to true or false (eg.: featured = true, so checkbox should be checked)
    column "Capa?", :sortable => :featured do |s|
      form do
        check_box "idea",
          :featured, :class => "form_idea", :data => {:url => admin_idea_path(s)},
          :checked => (s.featured? ? "checked" : "false")
      end
    end


    # Testing the position implementation
    # This will make the order in the featured page (eg.: ORDER BY position DESC)
    #column "Posição", :sortable => :position do |s|
    column :position, :sortable => :position do |s|
      form do
        select :class => "form_idea idea_position", :name => "idea[position]", "data-url" => admin_idea_path(s)  do
          0.upto(8).each do |n|
            if n == s.position
              option "#{n}", :value => "#{n}", :selected => "selected"
            else
              option "#{n}", :value => "#{n}"
            end
          end
        end
      end
    end


    # Here goes the "normal" index, just a list
    column :id
    column :title do |idea|
      div :class => "idea_show" do
        idea.title
      end
      div :class => "idea_hidden" do
        div :class => "category" do
          image_tag idea.category.badge.url, :size => "31x31"
        end
        h2 :class => "title" do
          idea.title
        end
        div do
          em idea.headline
        end
        strong "em #{idea.category.name} por #{idea.user.name}"
        hr
        p idea.description
      end
    end
    column :headline

    column :created_at do |s|
      s.created_at.strftime('%d/%m/%Y')
    end
    column :updated_at do |s|
      s.updated_at.strftime('%d/%m/%Y')
    end
    # Edit, View, Delete links
    default_actions
  end
end

