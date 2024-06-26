require 'rails_helper'

describe 'タスク管理機能', type: :system do

  # ユーザーA、Bをletで作成
  let(:user_a){FactoryBot.create(:admin_user, name: 'ユーザーA', email: 'a@example.com')}
  let(:user_b){FactoryBot.create(:admin_user, name: 'ユーザーB', email: 'b@example.com')}
  # ユーザーAのタスクをletで作成
  let!(:task_a){FactoryBot.create(:task, name: '最初のタスク', user: user_a)}

  before do
    # ユーザーXでログインする（共通処理）
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it {expect(page).to have_content '最初のタスク'}
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      # login_userの定義
      let(:login_user) {user_a}

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ユーザーBがログインしているとき' do
      # login_userの定義
      let(:login_user) {user_b}

      it 'ユーザーAのタスクが表示されない' do
        #ユーザーAのタスクが表示されないことを確認する
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) {user_a}

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) {user_a}

    before do
      visit new_task_path
      # ↓フォームのラベルが"名称"となっているフィールドにtask_nameという変数の値を入力
      fill_in '名称', with: task_name
      fill_in '詳しい説明', with: task_name
      click_button '登録する'
    end

    context '新規作成画面で名称を入力したとき' do
      let(:task_name) {'新規作成のテストを書く'}
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end

    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) {''}
      it 'エラーとなる' do
        within '#error_explanation' do
        expect(page).to have_content '名称を入力してください'
        end
      end
    end

  end


  describe '編集機能' do
    let(:login_user) {user_a}
    
    before do
      visit edit_task_path(task_a)
      fill_in '名称', with: task_rename
      fill_in '詳しい説明', with: task_rename
      click_button '更新する'
    end

    context '編集画面で名称と詳しい説明を編集したとき' do
      let(:task_rename) {'編集のテストを書く'}
      it '正常に登録される' do
        expect(page).to have_content '編集のテストを書く'
      end
    end
  end

end




# require 'rails_helper'

# describe 'タスク管理機能', type: :system do
#   let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
#   let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
#   let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

#   before do
#     visit login_path
#     fill_in 'メールアドレス', with: login_user.email
#     fill_in 'パスワード', with: login_user.password
#     click_button 'ログインする'
#   end

#   shared_examples_for 'ユーザーAが作成したタスクが表示される' do
#     it { expect(page).to have_content '最初のタスク' }
#   end

#   describe '一覧表示機能' do
#     context 'ユーザーAがログインしているとき' do
#       let(:login_user) { user_a }

#       it_behaves_like 'ユーザーAが作成したタスクが表示される'
#     end

#     context 'ユーザーBがログインしているとき' do
#       let(:login_user) { user_b }

#       it 'ユーザーAが作成したタスクが表示されない' do
#         expect(page).to have_no_content '最初のタスク'
#       end
#     end
#   end

#   describe '詳細表示機能' do
#     context 'ユーザーAがログインしているとき' do
#       let(:login_user) { user_a }

#       before do
#         visit task_path(task_a)
#       end

#       it_behaves_like 'ユーザーAが作成したタスクが表示される'
#     end
#   end

#   describe '新規作成機能' do
#     let(:login_user) { user_a }
#     let(:task_name) { '新規作成のテストを書く' } # デフォルトとして設定

#     before do
#       visit new_task_path
#       fill_in '名称', with: task_name
#       click_button '登録する'
#     end

#     context '新規作成画面で名称を入力したとき' do
#       it '正常に登録される' do
#         expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
#       end
#     end

#     context '新規作成画面で名称を入力しなかったとき' do
#       let(:task_name) { '' }

#       it 'エラーとなる' do
#         within '#error_explanation' do
#           expect(page).to have_content '名称を入力してください'
#         end
#       end
#     end
#   end
# end
