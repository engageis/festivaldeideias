# coding: utf-8

require 'spec_helper'

describe Audit do

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  
  describe "Validations/Associations" do
    it { should belong_to :user }
    it { should belong_to :idea }
  end

  describe ".audited_changes" do
    # Testing that it is serialized
    subject { Audit.make!(audited_changes: {likes: [51, 52]}) }
    its(:audited_changes) { should == {likes: [51, 52]} }
  end
  
  describe ".actual_user" do
    describe "with audit's user" do
      subject do
        @user = User.make!
        @idea = Idea.make!
        Audit.make!(user: @user, idea: @idea)
      end
      its(:actual_user) { should == @user }
    end
    describe "with ideas's user" do
      subject do
        @idea = Idea.make!
        Audit.make!(user: nil, idea: @idea)
      end
      its(:actual_user) { should == @idea.user }
    end
    ["likes_updated", "comments_updated"].each do |timeline_type|
      describe "with ideas's user, even when we have an user, for #{timeline_type}" do
        subject do
          @user = User.make!
          @idea = Idea.make!
          Audit.make!(user: @user, idea: @idea, timeline_type: timeline_type)
        end
        its(:actual_user) { should == @idea.user }
      end
    end
    ["collaboration_accepted", "collaboration_rejected"].each do |timeline_type|
      describe "with ideas's parent user, even when we have an user, for #{timeline_type}" do
        subject do
          @user = User.make!
          @parent = Idea.make!
          @idea = Idea.make!(parent: @parent)
          Audit.make!(user: @user, idea: @idea, timeline_type: timeline_type)
        end
        its(:actual_user) { should == @idea.parent.user }
      end
    end
  end
  
  describe ".text" do
    let(:parent) { Idea.make! }

    it "should display text when an idea was created" do
      audit = Audit.make!(action: "create", audited_changes: { "description" => "new", "accepted" => nil, "parent_id" => nil })
      audit.text.should == I18n.t("audit.create", user: audit.user.name, user_path: user_path(audit.user), idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea))
      audit.timeline_type.should == "idea_created"
    end
    
    it "should display text when an idea was edited by its creator" do
      audit = Audit.make!(action: "update", audited_changes: { "description" => ["old", "new"] })
      audit.text.should == I18n.t("audit.edit", user: audit.user.name, user_path: user_path(audit.user), idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea))
      audit.timeline_type.should == "edited_by_creator"
    end
    
    it "should display text when a collaboration is sent" do
      audit = Audit.make!(action: "create", audited_changes: { "parent_id" => parent.id, "accepted" => nil })
      audit.text.should == I18n.t("audit.collaboration.sent", user: audit.user.name, user_path: user_path(audit.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      audit.timeline_type.should == "collaboration_sent"
    end

    it "should display text when a collaboration is accepted" do
      audit = Audit.make!(idea: Idea.make!(parent: parent), action: "update", audited_changes: { "accepted" => [nil, true] })
      audit.text.should == I18n.t("audit.collaboration.accepted", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.idea.user.name, collaborator_path: user_path(audit.idea.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      audit.timeline_type.should == "collaboration_accepted"
    end

    it "should display text when a collaboration is rejected" do
      audit = Audit.make!(idea: Idea.make!(parent: parent), action: "update", audited_changes: { "accepted" => [nil, false] })
      audit.text.should == I18n.t("audit.collaboration.rejected", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.idea.user.name, collaborator_path: user_path(audit.idea.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      audit.timeline_type.should == "collaboration_rejected"
    end

    it "should display text when an idea is ramified" do
      audit = Audit.make!(idea: Idea.make!(parent: parent), action: "update", audited_changes: { "parent_id" => [parent.id, nil], "accepted" => [false, nil], "original_parent_id" => [nil, parent.id] })
      audit.text.should == I18n.t("audit.collaboration.ramified", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.actual_user.name, collaborator_path: user_path(audit.actual_user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      audit.timeline_type.should == "idea_ramified"
    end

    it "should display text when an idea's likes count was updated" do
      audit = Audit.make!(action: "update", audited_changes: { "likes" => [10, 20] })
      audit.text.should == I18n.t("audit.likes", idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea), likes: pluralize(20, "pessoa"))
      audit.timeline_type.should == "likes_updated"
    end
    
    it "should display text when an idea's comment count was updated" do
      audit = Audit.make!(action: "update", audited_changes: { "comment_count" => [10, 20] })
      audit.text.should == I18n.t("audit.comments", idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea), comments: pluralize(20, "comentário"))
      audit.timeline_type.should == "comments_updated"
    end
    
    it "should return nil if the idea was destroyed" do
      audit = Audit.make!(action: "destroy")
      audit.text.should == nil
    end
    
    it "should return nil if its idea does not exist anymore" do
      idea = Idea.make!
      audit = Audit.make!(idea: idea, action: "update", audited_changes: { "description" => ["old", "new"] })
      audit.text.should_not == nil
      idea.destroy
      audit.reload
      audit.text.should == nil
    end
    
    it "should return nil if the comment_count changed to zero" do
      audit = Audit.make!(action: "update", audited_changes: { "comment_count" => [10, 0] })
      audit.text.should == nil
    end
    
  end
  
end
