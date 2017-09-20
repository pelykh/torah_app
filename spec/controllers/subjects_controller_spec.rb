require 'rails_helper'

RSpec.describe SubjectsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:subj) { FactoryGirl.create(:subject) }

  context "when ActiveRecord::RecordNotFound is raised" do
    before do
      get :show, params: { id: "not id" }
    end

    it { is_expected.to respond_with :found }

    it { is_expected.to redirect_to subjects_url }

    it { is_expected.to set_flash }
  end

  describe "GET #show" do
    before do
      get :show, params: { id: subj.id }
    end

    it { is_expected.to respond_with :success }

    it { is_expected.to render_template :show }

    it "assigns subject" do
      expect(assigns(:subject)).to eq(subj)
    end
  end

  describe "GET #index" do
    before do
      10.times { FactoryGirl.create(:subject) }
      get :index
    end

    it { is_expected.to respond_with :success }

    it { is_expected.to render_template :index }

    it "assings subjects" do
      expect(assigns(:subjects)).to eq(Subject.includes(:children))
    end
  end

  describe "GET #edit" do
    before do
      get :edit, params: { id: subj.id }
    end

    it { is_expected.to respond_with :success }

    it { is_expected.to render_template :edit }

    it "assigns subject" do
      expect(assigns(:subject)).to eq(subj)
    end
  end

  describe "GET #new" do
    before do
      get :new, params: { id: subj.id }
    end

    it { is_expected.to respond_with :success }

    it { is_expected.to render_template :new }

    it "assigns subject" do
      expect(assigns(:subject)).to be_truthy
    end
  end

  describe "POST #create" do
    context "when requesting with valid data" do
      before do
        post :create, params: { subject: FactoryGirl.attributes_for(:subject) }
      end

      it "creates subject" do
        expect(Subject.count).to eq(1)
      end

      it { is_expected.to respond_with :found }

      it { is_expected.to redirect_to subject_url(Subject.first) }

      it { is_expected.to set_flash }
    end
  end

  describe "PATCH #update" do
    context "when requesting with valid data" do
      before do
        patch :update, params: { id: subj.id,
          subject: FactoryGirl.attributes_for(:subject, name: "new_name") }
      end

      it "updates subject" do
        expect(Subject.last.name).to eq("new_name")
      end

      it { is_expected.to respond_with :found }

      it { is_expected.to redirect_to subject_url(subj) }

      it { is_expected.to set_flash }
    end
  end

  describe "DELETE #destroy" do
    before do
      delete :destroy, params: { id: subj.id }
    end

    it "deletes subject" do
      expect(Subject.count).to eq(0)
    end

    it { is_expected.to respond_with :found }

    it { is_expected.to redirect_to subjects_url }

    it { is_expected.to set_flash }
    end
end
