# coding: utf-8

task :default_pages => :environment do

  dirname = File.join(File.expand_path(File.dirname(__FILE__)), 'pages')

  Dir.chdir(dirname) do
    Dir.new('.').each do |filename|

      # Eu só quero os arquivos ".txt"
      next if File.extname(filename) != '.txt'

      File.open(filename, 'r') do |file|
        lines = file.readlines
        title = lines.shift
        body = lines.join("\n")

        success = Page.create!(:title => title, :body => body)
        puts success
      end

    end
  end

end
