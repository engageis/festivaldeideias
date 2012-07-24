require 'spec_helper'

include Rails.application.routes.url_helpers

describe Audit do

  describe "Validations/Associations" do
    it { should belong_to :user }
    it { should belong_to :idea }
  end

  describe "#audited_changes" do
    # Testing that it is serialized
    subject { Audit.make!(audited_changes: {likes: [51, 52]}) }
    its(:audited_changes) { should == {likes: [51, 52]} }
  end
  
  describe "#text" do
    
    it "should display text when an idea was edited by its creator" do
      audit = Audit.make!(action: "update", audited_changes: { description: ["old", "new"] })
      audit.text.should == I18n.t("audit.edit", user: audit.user.name, user_path: user_path(audit.user), idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea))
    end
    
    it "should return nil if the idea was destroyed" do
      audit = Audit.make!(action: "destroy")
      audit.text.should == nil
    end
    
    it "should display text when an idea's likes count was updated" do
      audit = Audit.make!(action: "update", audited_changes: { likes: [10, 20] })
      audit.text.should == I18n.t("audit.likes", idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea), likes: 20)
    end
    
    it "should display text when a collaboration is sent" do
      parent = Idea.make!
      audit = Audit.make!(action: "create", audited_changes: { parent_id: parent.id, accepted: nil })
      audit.text.should == I18n.t("audit.collaboration.sent", user: audit.user.name, user_path: user_path(audit.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
    end

    it "should display text when a collaboration is accepted" do
      parent = Idea.make!
      audit = Audit.make!(idea: Idea.make!(parent: parent), action: "update", audited_changes: { accepted: [nil, true] })
      audit.text.should == I18n.t("audit.collaboration.accepted", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.user.name, collaborator_path: user_path(audit.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
    end

    it "should display text when a collaboration is rejected" do
      parent = Idea.make!
      audit = Audit.make!(idea: Idea.make!(parent: parent), action: "update", audited_changes: { accepted: [nil, false] })
      audit.text.should == I18n.t("audit.collaboration.rejected", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.user.name, collaborator_path: user_path(audit.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
    end

    it "should display text when an idea is ramified" do
      parent = Idea.make!
      audit = Audit.make!(idea: Idea.make!(parent: parent), action: "update", audited_changes: { parent_id: [parent.id, nil], accepted: [false, nil], original_parent_id: [nil, parent.id] })
      audit.text.should == I18n.t("audit.collaboration.ramified", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.user.name, collaborator_path: user_path(audit.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
    end

  end
  
end
