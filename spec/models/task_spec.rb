require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'タイトル、ステータスがあれば有効な状態であること' do
      expect(FactoryBot.build(:task)).to be_valid
    end

    it 'タイトルが無ければ無効な状態であること' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'ステータスが無ければ無効な状態であること' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it '重複したタイトルなら無効な状態であること' do
      FactoryBot.create(:task, title: 'test')
      task = FactoryBot.build(:task, title: 'test')
      task.valid?
      expect(task.errors[:title]).to include("has already been taken")
    end

    it '重複しないタイトルなら有効な状態であること' do
      FactoryBot.create(:task)
      expect(FactoryBot.build(:task)).to be_valid
    end
  end
end
