require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:user_params) { FactoryGirl.attributes_for(:user, moderator: true) }

  describe "GET #edit_user" do
    context "when admin" do
      before do
        sign_in admin
        get :edit_user, params: { id: user.id }
      end

      it { is_expected.to respond_with :success }

      it { is_expected.to render_template :edit_user }

      it "assigns user" do
        expect(assigns(:user)).to eq(user)
      end
    end

    context "when not admin" do
      before do
        sign_in user
        get :edit_user, params: { id: user.id }
      end

      it { is_expected.to redirect_to subjects_url }
    end
  end

  describe "PATCH #update_user" do
    context "when admin" do
      before do
        sign_in admin
        get :update_user, params: { id: user.id, user: user_params }
      end

      it { is_expected.to respond_with :found }

      it { is_expected.to redirect_to user_url(user) }

      it "assigns user" do
        expect(assigns(:user)).to eq(user)
      end

      it do
        is_expected.to permit(:moderator, :verified)
          .for(:update_user, verb: :post, params: { id: user.id, user: user_params })
          .on(:user)
      end

      it "updates_user" do
        expect(User.last.moderator).to eq(true)
      end
    end

    context "when not admin" do
      before do
        sign_in user
        get :update_user, params: { id: user.id, user: user_params }
      end

      it { is_expected.to redirect_to subjects_url }
    end
  end
end
