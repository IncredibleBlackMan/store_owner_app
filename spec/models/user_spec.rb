require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    before(:all) do
      @user = create(:user)
    end

    it 'User model should have valid attributes' do
      expect(@user).to be_valid
    end
  end
end
