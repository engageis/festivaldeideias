# coding: utf-8

require 'spec_helper'

describe Page do

  before do
    Page.make!
  end
  describe "Validations/Associations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_uniqueness_of :title }
  end

  describe "Slug verification" do
    it 'Should convert the page title to a friendly_id' do
      number = rand(1000)
      page = Page.make!(:title => "Minha Página Especial #{number}", :body => '<p>Conteúdo</p>')
      page.slug.should == "minha-pagina-especial-#{number}"
    end
  end
end

