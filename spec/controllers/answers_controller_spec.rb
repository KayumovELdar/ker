require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }
  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        end.not_to change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
