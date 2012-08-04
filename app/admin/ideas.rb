# coding: utf-8
ActiveAdmin.register Idea do
  menu :label => "Curação de ideias"
  controller do
    def scoped_collection
      end_of_association_chain.without_parent
    end
  end

  csv do

    column("Moderador")               { |idea| idea.user.name }
    column("Título")                  { |idea| idea.title }
    column("Valor do investimento")   { |idea| idea.minimum_investment }
    column("URL")                     { |idea| category_idea_url(idea.category, idea) }
    column("Causa")                   { |idea| idea.category.name }
    column("Número de colaboradores") { |idea| idea.colaborations.size }
    column("Número de likes")         { |idea| idea.likes }
    column("Ideia primária")          { |idea| idea.original_parent.nil? ? '' : idea.original.parent.title }

  end

  # Initial Implementation of featured / position ajax submition
  #
  index do

    # Testing the featured? implementation
    # This will change the boolean column to true or false (eg.: featured = true, so checkbox should be checked)
    column "Capa?", :sortable => :featured do |s|
      if !s.parent_id
        form do
          check_box "idea",
            :featured, :class => "form_idea", :data => {:url => admin_idea_url(s)},
            :checked => (s.featured? ? "checked" : "false")
        end
      end
    end


    # Testing the position implementation
    # This will make the order in the featured page (eg.: ORDER BY position DESC)
    #column "Posição", :sortable => :position do |s|
    column :position, :sortable => :position do |s|
      if !s.parent_id
        form do
          select :class => "form_idea idea_position", :name => "idea[position]", "data-url" => admin_idea_url(s)  do
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
    end


    # Here goes the "normal" index, just a list
    column :id
    column :title do |idea|
      div :class => "idea_show" do
        if idea.parent_id
          strong "[colaboração] #{idea.title}"
        else
          idea.title
        end
      end
      div :class => "idea_hidden" do
        div :class => "category" do
          image_tag idea.category.badge, :size => "31x31"
        end
        h2 :class => "title" do
          idea.title
        end
        div do
          em idea.description_html
        end
        strong "em #{idea.category.name} por #{idea.user.name}"
        hr
        p idea.description
      end
    end

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

