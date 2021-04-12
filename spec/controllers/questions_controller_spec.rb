require 'rails_helper'
require Rails.root.join "spec/controllers/concerns/voted_spec.rb"

RSpec.describe QuestionsController, type: :controller do

  it_behaves_like 'voted'

  let(:question) { create(:question, user: user) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end


    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }
    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end


    it 'assigns a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'asigns new badges for question' do
      expect(assigns(:question).badge).to be_a_new(Badge)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'assigns edit question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js  }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js  }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js  }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not change question' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js  }
        end.to_not change { question.reload.updated_at }
      end

      it 're-renders edit view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js  }

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User is author' do
      before { login(user) }
      let!(:question) { create(:question, user: user) }

      it 'check that answer was deleted' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions list' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Unauthorized user' do
      let!(:question) { create(:question) }
      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end



end
