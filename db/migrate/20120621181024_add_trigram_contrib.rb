class AddTrigramContrib < ActiveRecord::Migration
  def change
    execute "CREATE extension pg_trgm"
    execute "CREATE extension fuzzystrmatch"
  end
end
