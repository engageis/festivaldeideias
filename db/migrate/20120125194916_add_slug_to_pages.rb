class AddSlugToPages < ActiveRecord::Migration
  def change
    add_column :pages, :slug, :string
    add_index :pages, :slug
  end
end
