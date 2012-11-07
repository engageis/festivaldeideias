class AddPgExtensionsToDatabase < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
    execute "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;"
    execute "CREATE EXTENSION IF NOT EXISTS unaccent;"
  end

  def down
    execute "DROP EXTENSION pg_trgm;"
    execute "DROP EXTENSION fuzzystrmatch;"
    execute "DROP EXTENSION unaccent;"
  end
end
