# coding: utf-8

require 'spec_helper'

describe Audit do

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  
  describe "Validations/Associations" do
    it { should belong_to :user }
    it { should belong_to :idea }
    it { should belong_to :actual_user }
    it { should belong_to :parent }
  end
  
  describe ".audited_changes" do
    # Testing that it is serialized
    subject { Audit.make!(audited_changes: {likes: [51, 52]}) }
    its(:audited_changes) { should == {likes: [51, 52]} }
  end

  describe ".notification_texts" do
    # Testing that it is serialized
    subject { Audit.make!(notification_texts: {collaborators: "collaborators", creator: "creator"}) }
    its(:notification_texts) { should == {collaborators: "collaborators", creator: "creator"} }
  end

  # IMPORTANT NOTICE for developers: this method is called by migration StoreAuditsTimelineData.
  # If you remove it or change its behaviour, please edit the migration as well
  describe ".set_timeline_and_notifications_data!" do
    let(:parent) { Idea.make! }
    subject do
      @audit = Audit.make!(audited_changes: {likes: [51, 52]}, timeline_type: nil, actual_user: nil, parent: nil, text: nil, notification_texts: nil)
      @audit.set_timeline_and_notifications_data!
      @audit
    end
    its(:text) { should == @audit.generated_texts[0] }
    its(:notification_texts) { should == @audit.generated_texts[1] }
    its(:timeline_type) { should == @audit.generated_timeline_type }
    its(:actual_user_id) { should == @audit.generated_actual_user_id }
    its(:parent_id) { should == @audit.generated_parent_id }
    
    it "should display text when an idea was created" do
      audit = Audit.make!(action: "create", audited_changes: { "description" => "new", "accepted" => nil, "parent_id" => nil })
      audit.set_timeline_and_notifications_data!
      timeline_text = I18n.t("audit.create", user: audit.user.name, user_path: user_path(audit.user), idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea))
      notification_texts = nil
      audit.timeline_type.should == "idea_created"
      audit.text.should == timeline_text
      audit.notification_texts.should == notification_texts
    end
        
    it "should display text when an idea was edited by its creator" do
      audit = Audit.make!(action: "update", audited_changes: { "description" => ["old", "new"] })
      audit.set_timeline_and_notifications_data!
      timeline_text = I18n.t("audit.edit", user: audit.user.name, user_path: user_path(audit.user), idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea))
      notification_texts = {
        collaborators: I18n.t("audit.notification.edit.collaborators", user: audit.user.name, user_path: user_path(audit.user), idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea))
      }
      audit.timeline_type.should == "edited_by_creator"
      audit.text.should == timeline_text
      audit.notification_texts.should == notification_texts
    end
    
    it "should display text when a collaboration is sent" do
      audit = Audit.make!(action: "create", audited_changes: { "parent_id" => parent.id, "accepted" => nil })
      audit.set_timeline_and_notifications_data!
      timeline_text = I18n.t("audit.collaboration.sent", user: audit.user.name, user_path: user_path(audit.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      notification_texts = {
        creator: I18n.t("audit.notification.collaboration.sent.creator", user: audit.user.name, user_path: user_path(audit.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent)),
        collaborators: I18n.t("audit.notification.collaboration.sent.collaborators", user: audit.user.name, user_path: user_path(audit.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      }
      audit.timeline_type.should == "collaboration_sent"
      audit.text.should == timeline_text
      audit.notification_texts.should == notification_texts
    end
    
    it "should display text when a collaboration is accepted" do
      audit = Audit.make!(idea: Idea.make!(parent: parent), action: "update", audited_changes: { "accepted" => [nil, true] })
      audit.set_timeline_and_notifications_data!
      timeline_text = I18n.t("audit.collaboration.accepted", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.idea.user.name, collaborator_path: user_path(audit.idea.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      notification_texts = {
        collaborators: I18n.t("audit.notification.collaboration.accepted.collaborators", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.idea.user.name, collaborator_path: user_path(audit.idea.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent)),
        accepted_collaborator: I18n.t("audit.notification.collaboration.accepted.accepted_collaborator", user: parent.user.name, user_path: user_path(parent.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      }
      audit.timeline_type.should == "collaboration_accepted"
      audit.text.should == timeline_text
      audit.notification_texts.should == notification_texts
    end
    
    it "should display text when a collaboration is rejected" do
      audit = Audit.make!(idea: Idea.make!(parent: parent), action: "update", audited_changes: { "accepted" => [nil, false] })
      audit.set_timeline_and_notifications_data!
      timeline_text = I18n.t("audit.collaboration.rejected", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.idea.user.name, collaborator_path: user_path(audit.idea.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      notification_texts = {
        collaborators: I18n.t("audit.notification.collaboration.rejected.collaborators", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.idea.user.name, collaborator_path: user_path(audit.idea.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent)),
        rejected_collaborator: I18n.t("audit.notification.collaboration.rejected.rejected_collaborator", user: parent.user.name, user_path: user_path(parent.user), idea: parent.title, idea_path: category_idea_path(parent.category, parent), ramify_path: ramify_idea_path(audit.idea))
      }
      audit.timeline_type.should == "collaboration_rejected"
      audit.text.should == timeline_text
      audit.notification_texts.should == notification_texts
    end
    
    it "should display text when an idea is ramified" do
      audit = Audit.make!(idea: Idea.make!(parent: parent), action: "update", audited_changes: { "parent_id" => [parent.id, nil], "accepted" => [false, nil], "original_parent_id" => [nil, parent.id] })
      audit.set_timeline_and_notifications_data!
      timeline_text = I18n.t("audit.collaboration.ramified", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.actual_user.name, collaborator_path: user_path(audit.actual_user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      notification_texts = {
        creator: I18n.t("audit.notification.collaboration.ramified.creator", collaborator: audit.actual_user.name, collaborator_path: user_path(audit.actual_user), idea: parent.title, idea_path: category_idea_path(parent.category, parent)),
        collaborators: I18n.t("audit.notification.collaboration.ramified.collaborators", user: parent.user.name, user_path: user_path(parent.user), collaborator: audit.actual_user.name, collaborator_path: user_path(audit.actual_user), idea: parent.title, idea_path: category_idea_path(parent.category, parent))
      }
      audit.timeline_type.should == "idea_ramified"
      audit.text.should == timeline_text
      audit.notification_texts.should == notification_texts
    end
    
    it "should display text when an idea's likes count was updated" do
      audit = Audit.make!(action: "update", audited_changes: { "likes" => [10, 20] })
      audit.set_timeline_and_notifications_data!
      timeline_text = I18n.t("audit.likes", idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea), likes: pluralize(20, "pessoa"))
      notification_texts = {
        creator: I18n.t("audit.notification.likes.creator", idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea), likes: pluralize(20, "pessoa")),
        collaborators: I18n.t("audit.notification.likes.collaborators", idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea), likes: pluralize(20, "pessoa"))
      }
      audit.timeline_type.should == "likes_updated"
      audit.text.should == timeline_text
      audit.notification_texts.should == notification_texts
    end
    
    it "should display text when an idea's comment count was updated" do
      audit = Audit.make!(action: "update", audited_changes: { "comment_count" => [10, 20] })
      audit.set_timeline_and_notifications_data!
      timeline_text = I18n.t("audit.comments", idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea), comments: pluralize(20, "comentário"))
      notification_texts = {
        creator: I18n.t("audit.notification.comments.creator", idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea), comments: pluralize(20, "comentário")),
        collaborators: I18n.t("audit.notification.comments.collaborators", idea: audit.idea.title, idea_path: category_idea_path(audit.idea.category, audit.idea), comments: pluralize(20, "comentário"))
      }
      audit.timeline_type.should == "comments_updated"
      audit.text.should == timeline_text
      audit.notification_texts.should == notification_texts
    end
    
    it "should return ignore if the idea was destroyed" do
      audit = Audit.make!(action: "destroy")
      audit.set_timeline_and_notifications_data!
      audit.timeline_type.should == "ignore"
      audit.text.should == nil
      audit.notification_texts.should == nil
    end
    
    it "should return ignore if its idea does not exist anymore" do
      idea = Idea.make!
      audit = Audit.make!(idea: idea, action: "update", audited_changes: { "description" => ["old", "new"] })
      idea.destroy
      audit.reload
      audit.set_timeline_and_notifications_data!
      audit.timeline_type.should == "ignore"
      audit.text.should == nil
      audit.notification_texts.should == nil
    end
    
    it "should return ignore if the comment_count changed to zero" do
      audit = Audit.make!(action: "update", audited_changes: { "comment_count" => [10, 0] })
      audit.set_timeline_and_notifications_data!
      audit.timeline_type.should == "ignore"
      audit.text.should == nil
      audit.notification_texts.should == nil
    end

  end
  
  describe ".generated_actual_user" do
    describe "with audit's user" do
      subject do
        @user = User.make!
        @idea = Idea.make!
        Audit.make!(user: @user, idea: @idea)
      end
      its(:generated_actual_user_id) { should == @user.id }
    end
    describe "with ideas's user" do
      subject do
        @idea = Idea.make!
        Audit.make!(user: nil, idea: @idea)
      end
      its(:generated_actual_user_id) { should == @idea.user.id }
    end
    ["likes_updated", "comments_updated"].each do |timeline_type|
      describe "with ideas's user, even when we have an user, for #{timeline_type}" do
        subject do
          @user = User.make!
          @idea = Idea.make!
          Audit.make!(user: @user, idea: @idea, timeline_type: timeline_type)
        end
        its(:generated_actual_user_id) { should == @idea.user.id }
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
        its(:generated_actual_user_id) { should == @idea.parent.user.id }
      end
    end
  end
  
  describe ".users_to_notify" do
    before do
      @original_parent = Idea.make!(parent: nil, original_parent: nil)
      @ramified = Idea.make!(parent: nil, original_parent: @original_parent)
      @ramified_1 = Idea.make!(parent: nil, original_parent: @original_parent)
      @collaboration_1 = Idea.make!(parent: @ramified, accepted: true)
      @collaboration_2 = Idea.make!(parent: @ramified, accepted: true)
      @collaboration_3 = Idea.make!(user: @collaboration_1.user, parent: @ramified, accepted: true)
    end
    describe "activity in an original parent" do
      subject { Audit.make!(idea: @original_parent) }
      its(:users_to_notify) { should == [@original_parent.user] }
    end
    describe "activity in a ramified idea with collaborators" do
      subject { Audit.make!(idea: @ramified) }
      its(:users_to_notify) { should == [@ramified.user, @collaboration_1.user, @collaboration_2.user] }
    end
    describe "activity in a ramified idea with no collaborators" do
      subject { Audit.make!(idea: @ramified_1) }
      its(:users_to_notify) { should == [@ramified_1.user] }
    end
    describe "activity in a collaboration" do
      subject { Audit.make!(idea: @collaboration_1) }
      its(:users_to_notify) { should == [@collaboration_1.user, @ramified.user, @collaboration_2.user] }
    end
  end
  
  describe ".notification_subject" do
    describe "idea created" do
      subject { @audit = Audit.make!(timeline_type: "idea_created") }
      its(:notification_subject) { should == "Tem ideia nova no FdI" }
    end
    describe "edited by creator" do
      subject { @audit = Audit.make!(timeline_type: "edited_by_creator") }
      its(:notification_subject) { should == "Tem novidades na ideia #{@audit.idea.title}" }
    end
    describe "likes updated" do
      subject { @audit = Audit.make!(timeline_type: "likes_updated") }
      its(:notification_subject) { should == "Tem gente curtindo a ideia #{@audit.idea.title}" }
    end
    describe "comments updated" do
      subject { @audit = Audit.make!(timeline_type: "comments_updated") }
      its(:notification_subject) { should == "Novos comentários na ideia #{@audit.idea.title}" }
    end
    describe "collaboration sent" do
      subject do
        @idea = Idea.make!(parent: Idea.make!)
        @audit = Audit.make!(idea: @idea, timeline_type: "collaboration_sent")
      end
      its(:notification_subject) { should == "Colaboração enviada para a ideia #{@audit.idea.parent.title}" }
    end
    describe "collaboration accepted" do
      subject do
        @idea = Idea.make!(parent: Idea.make!)
        @audit = Audit.make!(idea: @idea, timeline_type: "collaboration_accepted")
      end
      its(:notification_subject) { should == "Colaboração aceita na ideia #{@audit.idea.parent.title}" }
    end
    describe "collaboration rejected" do
      subject do
        @idea = Idea.make!(parent: Idea.make!)
        @audit = Audit.make!(idea: @idea, timeline_type: "collaboration_rejected")
      end
      its(:notification_subject) { should == "Colaboração recusada na ideia #{@audit.idea.parent.title}" }
    end
    describe "idea ramified" do
      subject do
        @idea = Idea.make!(parent: Idea.make!)
        @audit = Audit.make!(idea: @idea, timeline_type: "idea_ramified")
      end
      its(:notification_subject) { should == "A ideia #{@audit.idea.parent.title} foi ramificada" }
    end
  end

end
