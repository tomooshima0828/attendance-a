require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  describe 'バリデーションについて' do
    it 'バリデーションが通ること' do
      expect(user).not_to be_valid
    end
  end
end
