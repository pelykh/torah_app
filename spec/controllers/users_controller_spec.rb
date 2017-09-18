require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryGirl.create(:user) }

  describe "GET #show" do
    before do
      get :show, params: { id: user.id }
    end

    it { is_expected.to respond_with :success }

    it { is_expected.to render_template :show }
  end
end
