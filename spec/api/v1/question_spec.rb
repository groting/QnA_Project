require 'rails_helper'
require_relative 'concerns/unauthenticated.rb'

describe 'Questions API' do
  describe 'GET /index' do

    it_behaves_like 'unauthenticated' do
      let(:request_to_resource) { get '/api/v1/questions', as: :json }
      let(:request_with_invalid_token) { get '/api/v1/questions',
          as: :json, params: { access_token: '12345' } }
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', as: :json, params: {access_token: access_token.token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).
            to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
              .at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question) }

    it_behaves_like 'unauthenticated' do
      let(:request_to_resource) { get api_v1_question_path(question), as: :json }
      let(:request_with_invalid_token) { get api_v1_question_path(question),
          as: :json, params: { access_token: '12345' } }
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      before do
        file = File.open("#{Rails.root}/spec/spec_helper.rb")
        question.attachments.create(file: file)
      end
      before { get api_v1_question_path(question), as: :json, params: {access_token: access_token.token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at rating).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).
            to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).
              to be_json_eql(comment.send(attr.to_sym).to_json).
                at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do


        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'contains url' do
          expect(response.body).
            to be_json_eql(question.attachments.first.file.url.to_json).
              at_path('question/attachments/0/url')
        end
      end
    end
  end

  describe 'POST /create' do

    it_behaves_like 'unauthenticated' do
      let(:request_to_resource) { post api_v1_questions_path, as: :json }
      let(:request_with_invalid_token) { post api_v1_questions_path,
          as: :json, params: { access_token: '12345' } }
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      let(:params) {
                      {
                        as: :json, params:
                        {
                          access_token: access_token.token,
                          question: attributes_for(:question)
                        }
                      }
                    }
      it 'returns 201 status' do
        post api_v1_questions_path, params
        expect(response.status).to eq 201
      end

      it 'creates new question' do
        expect { post api_v1_questions_path, params }.to change(Question.all, :count).by(1)
      end

      %w(id title body created_at updated_at rating).each do |attr|
        it "question object contains #{attr}" do
          post api_v1_questions_path, params
          expect(response.body).
            to be_json_eql(Question.first.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'with invalid attributes' do
        let(:params) {
                        {
                          as: :json, params:
                          {
                            access_token: access_token.token,
                            question: { title: nil, body: 'Body' }
                          }
                        }
                      }

        it 'returns 422 status' do
          post api_v1_questions_path, params
          expect(response.status).to eq 422
        end

        it 'returns error when title is nil' do
          post api_v1_questions_path, params
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/title/0/')
        end

        it 'returns error when body is nil' do
          post api_v1_questions_path, as: :json, params: {
                                                          access_token: access_token.token,
                                                          question: { title: 'Title', body: nil }
                                                          }
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0/')
        end

        it 'does not create question in database' do
          expect { post api_v1_questions_path, params }.to_not change(Question.all, :count)
        end
      end
    end
  end
end