class AddPgExtensionsToDatabase < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION pg_trgm;"
    execute "CREATE EXTENSION fuzzystrmatch;"
    execute "CREATE EXTENSION unaccent;"
  end

  def down
    execute "DROP EXTENSION pg_trgm;"
    execute "DROP EXTENSION fuzzystrmatch;"
    execute "DROP EXTENSION unaccent;"
  end
end
