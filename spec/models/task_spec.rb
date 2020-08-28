require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'タイトル、ステータスがあれば有効な状態であること' do
      task = build(:task)
      expect(task).to be_valid
    end

    it 'タイトルが無ければ無効な状態であること' do
      task_without_title = build(:task, title: nil)
      task_without_title.valid?
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end

    it 'ステータスが無ければ無効な状態であること' do
      task_without_status = build(:task, status: nil)
      task_without_status.valid?
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end

    it '重複したタイトルなら無効な状態であること' do
      task = create(:task)
      task_with_duplicated_title = build(:task, title: task.title)
      task_with_duplicated_title.valid?
      expect(task_with_duplicated_title.errors[:title]).to include("has already been taken")
    end

    it '重複しないタイトルなら有効な状態であること' do
      task = create(:task)
      task_with_another_title = build(:task, title: 'another_title')
      expect(task_with_another_title).to be_valid
    end
  end
end
