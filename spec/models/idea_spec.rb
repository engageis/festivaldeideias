require 'spec_helper'
describe Idea do

  include Rails.application.routes.url_helpers
  describe "Validations/Associations" do

    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :category_id }
    it { should validate_presence_of :user_id }
    it { should belong_to :user }
    it { should belong_to :category }
    it { should have_many(:collaborators).dependent(:destroy) }

    describe "#as_json" do
      it "Should return a given json output" do
        @idea = Idea.make!
        idea_json = {
          id: @idea.id,
          title: @idea.title,
          headline: @idea.headline,
          category: @idea.category,
          user: @idea.user.id,
          description: @idea.description,
          description_html: @idea.description_html,
          likes: @idea.likes,
          collaborators: @idea.collaborators.count,
          minimum_investment: @idea.minimum_investment,
          formatted_minimum_investment: @idea.formatted_minimum_investment,
          url: @idea.as_json[:url],
          latitude: @idea.as_json[:latitude],
          longitude: @idea.as_json[:longitude],
          city: @idea.as_json[:city],
          state: @idea.as_json[:state],
          country: @idea.as_json[:country]
        }
        @idea.as_json.should == idea_json
      end
    end

    describe "#to_param" do
      it "Should concatenate id and title" do
        @idea = Idea.make!
        @idea.to_param.should == "#{@idea.id}-#{@idea.title.parameterize}"
      end
    end


    describe "#description_html" do
      it "Should convert the description to html" do
        string = "<p>This is a description</p>\n"
        @idea = Idea.make!(:description => "This is a description")
        @idea.description_html.should == string
      end
    end

    describe "#convert_html" do
      it "Should convert any text to html format" do
        str = "This is a string with a link: http://google.com"
        str_html = "<p>This is a string with a link: <a href=\"http://google.com\" target=\"_blank\">http://google.com</a></p>\n"

        @idea = Idea.make!
        @idea.convert_html(str).should == str_html
      end
    end

  end

  describe "#check_minimum_investment" do
    it "Should format minimum investment as currency" do 
      @idea = Idea.make! minimum_investment: "5000.25"
      @idea.formatted_minimum_investment.should  == "R$ 5.000,25"
    end

    it "Should format minimum investiment corretly when receiving currency symbols" do
      @idea = Idea.make! minimum_investment: "5100.00" 
      @idea.formatted_minimum_investment.should  == "R$ 5.100,00"
    end

    it "Should format minimum investiment corretly when receiving wrong format" do
      @idea = Idea.make! minimum_investment: "5101.25" 
      @idea.formatted_minimum_investment.should  == "R$ 5.101,25"
    end
  end

  describe "#external_url" do
    it "Should return a correct url for facebook comments and likes" do
      @idea = Idea.make! title: "My Title"
      @idea.external_url.should == "http://festivaldeideias.org.br/ideas/#{@idea.id}"
    end
  end

  describe "#match_and_find" do
    before do
      @idea   = Idea.make!(title: "cat", description: "cat")
      @idea_1 = Idea.make!(title: "ca", description: "ca")
      @idea_2 = Idea.make!(title: "at", description: "at")
      @idea_3 = Idea.make!(title: "yzv")
      @idea_user = Idea.make!(title: "with user", user: User.make!(name: "Paul McCartney"))
    end

    subject { Idea.match_and_find("ca") }
    it "Should return a set of results based on trigrams" do
      subject.should_not include(@idea)
      subject.should include(@idea_1)
      subject.should_not include(@idea_2)
      subject.should_not include(@idea_3)
      subject.should_not include(@idea_user)
    end

    describe "By user" do
     subject { Idea.match_and_find("McCartney") }
     it "Should search by user name" do
       subject.should_not include(@idea)
       subject.should_not include(@idea_1)
       subject.should_not include(@idea_2)
       subject.should_not include(@idea_3)
       subject.should include(@idea_user)
     end
    end

  end
  
  describe "#ip_for_geocoding" do
    subject do
      @idea = Idea.make!
      @idea.update_attribute :likes, 10
      @audits = Audit.where(auditable_id: @idea.id).order(:created_at)
      @audits.shift.update_attribute :remote_address, nil
      @audits.shift.update_attribute :remote_address, "1.1.1.1"
      @audits.shift.update_attribute :remote_address, "2.2.2.2"
      @idea
    end
    its(:ip_for_geocoding) { should == "1.1.1.1" }
  end

  describe "#display_latitude" do
    describe "the user has a latitude" do
      subject { Idea.make!(latitude: 10, user: User.make!(latitude: 20)) }
      its(:display_latitude) { should == 20 }
    end
    describe "the user doesn't have a latitude" do
      subject { Idea.make!(latitude: 10, user: User.make!(latitude: nil)) }
      its(:display_latitude) { should == 10 }
    end
  end
  
  describe "#display_longitude" do
    describe "the user has a longitude" do
      subject { Idea.make!(longitude: 10, user: User.make!(longitude: 20)) }
      its(:display_longitude) { should == 20 }
    end
    describe "the user doesn't have a longitude" do
      subject { Idea.make!(longitude: 10, user: User.make!(longitude: nil)) }
      its(:display_longitude) { should == 10 }
    end
  end
  
  describe "#display_city" do
    describe "the user has a city" do
      subject { Idea.make!(city: "Porto Alegre", user: User.make!(city: "Canoas")) }
      its(:display_city) { should == "Canoas" }
    end
    describe "the user doesn't have a city" do
      subject { Idea.make!(city: "Porto Alegre", user: User.make!(city: nil)) }
      its(:display_city) { should == "Porto Alegre" }
    end
  end
  
  describe "#display_state" do
    describe "the user has a state" do
      subject { Idea.make!(state: "RS", user: User.make!(state: "SC")) }
      its(:display_state) { should == "SC" }
    end
    describe "the user doesn't have a state" do
      subject { Idea.make!(state: "RS", user: User.make!(state: nil)) }
      its(:display_state) { should == "RS" }
    end
  end
  
  describe "#display_country" do
    describe "the user has a country" do
      subject { Idea.make!(country: "Brazil", user: User.make!(country: "Uruguay")) }
      its(:display_country) { should == "Uruguay" }
    end
    describe "the user doesn't have a country" do
      subject { Idea.make!(country: "Brazil", user: User.make!(country: nil)) }
      its(:display_country) { should == "Brazil" }
    end
  end
  
end
