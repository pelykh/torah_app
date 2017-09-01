require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = FactoryGirl.build(:user)
  end

  test "user factory is valid" do
    assert @user.valid?
  end

  test "name should be longer than or equal to 6" do
    @user.name = "name1"
    assert @user.invalid?
  end

  test "name should be less than or equal to 20" do
    @user.name = "n" * 21
    assert @user.invalid?
  end
end
