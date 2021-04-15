require 'rails_helper'
require Rails.root.join "spec/controllers/concerns/voted_controller_spec.rb"

RSpec.describe AnswersController, type: :controller do
  it_behaves_like "voted"

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do

    before { login(user) }

    context 'with valid attributes' do

      it 'saves a new answer in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        end.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'User is author' do
      before { login(user) }

      it 'check that answer was deleted' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'User is not author' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer },format: :js }.to_not change(Answer, :count)
      end
    end

    context 'Unauthorized user' do

      it 'tries to delete answer' do
        expect { delete :destroy, params: {id: answer}, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authorized user edits his answer with valid attributes' do
      before { login(user) }

      it 'changes answer attributes' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Authorized user edits his answer with invalid attributes' do
      before { login(user) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
        expect(response).to render_template :update
      end
    end

    context 'User is not author' do
      let(:other_user) { create(:user) }
      before { login(:other_user) }

      it "tries to edit others's user answer" do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end

    context 'Unauthorized user' do
      it 'tries to edit answer' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end

      it 'needs to login in order to proceed' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response.body).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'PATCH #set_best' do
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author)}
    let(:answer) { create(:answer, question: question, user: author) }

    context 'User is author of question' do
      before { login(author) }

      it 'set best answer' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to eq true
      end

      it 'renders set_best view' do
        patch :set_best, params: { id: answer, answer: { body: 'new body'}, format: :js }
        expect(response).to render_template :set_best
      end
    end

    context 'User is not author of question' do
      before { login(user) }

      it 'tries to set best answer' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end

    context 'Unauthorized user' do
      it 'tries to set best answer' do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end
end
