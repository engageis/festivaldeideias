# coding: utf-8
ActiveAdmin.register User do
  menu label: "Usuários do Facebook", priority: 1, parent: "Usuários"

  index do
    column :name
    column :email
    # column :telephone
    column :city
    column :state
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name, as: :string
      f.input :email, as: :string
      # f.input :telephone, as: :string
      f.input :city, as: :string
      f.input :state, as: :string
    end
    f.buttons
  end
  
  show title: :name do |user|
    attributes_table do
      row :name
      row :email
      # row :telephone
      row :city
      row :state
      row :email_notifications do |user|
        if user.email_notifications then "Sim" else "Não" end
      end
      row :created_at
      row :updated_at
    end
  end

end
