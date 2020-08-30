require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user){ create(:user) }
  let(:login_user){ create(:user) }
  let(:task){ create(:task, user: user) }

  describe 'ログイン前' do
    context 'タスク新規作成' do
      it 'タスクの新規作成ページへのアクセスが失敗する' do
        visit new_task_path
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
    end
    context 'タスク編集' do
      it 'タスクの編集ページへのアクセスが失敗する' do
        visit edit_task_path(task)
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
    end
    context 'タスクの詳細ページにアクセス' do
      it 'タスクの詳細情報が表示される' do
        visit task_path(task)
        expect(page).to have_content task.title
        expect(current_path).to eq task_path(task)
      end
    end
    context 'タスクの一覧ページにアクセス' do
      it 'すべてのユーザーのタスク情報が表示される' do
        task_list = create_list(:task, 3)
        visit tasks_path
        expect(page).to have_content task_list[0].title
        expect(page).to have_content task_list[1].title
        expect(page).to have_content task_list[2].title
        expect(current_path).to eq tasks_path
      end
    end
  end


  describe 'ログイン後' do
    before { login user }
    describe 'タスク新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'test'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: nil
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe 'タスク編集' do
      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'test_edit'
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content 'Task was successfully updated.'
          expect(current_path).to eq task_path(task)
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: nil
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスク削除' do
      context '自分の掲示板' do
        it 'タスクの削除が成功する' do
          task
          visit tasks_path
          page.accept_confirm do
            click_link 'Destroy'
          end
          expect(page).to have_content 'Task was successfully destroyed.'
          expect(current_path).to eq tasks_path
        end
      end
    end
  end
end
