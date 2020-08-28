require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'タイトル、ステータスがあれば有効な状態であること' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    it 'タイトルが無ければ無効な状態であること' do
      task_without_title = build(:task, title: nil)
      task_without_title.valid?
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to eq ["can't be blank"]
    end

    it 'ステータスが無ければ無効な状態であること' do
      task_without_status = build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to eq ["can't be blank"]
    end

    it '重複したタイトルなら無効な状態であること' do
      task = create(:task)
      task_with_duplicated_title = build(:task, title: task.title)
      expect(task_with_duplicated_title).to be_invalid
      expect(task_with_duplicated_title.errors[:title]).to eq ["has already been taken"]
    end

    it '重複しないタイトルなら有効な状態であること' do
      task = create(:task)
      task_with_another_title = build(:task, title: 'another_title')
      expect(task_with_another_title).to be_valid
      expect(task.errors).to be_empty
    end
  end
end
