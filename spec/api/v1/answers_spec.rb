require 'rails_helper'
require_relative 'concerns/unauthenticated.rb'

describe 'Answers API' do
  let(:question) { create(:question) }
  describe 'GET /index' do

    it_behaves_like 'unauthenticated' do
      let(:request_to_resource) { get api_v1_question_answers_path(question), as: :json }
      let(:request_with_invalid_token) { get api_v1_question_answers_path(question),
          as: :json, params: { access_token: '12345' } }
    end

    context 'authenticated' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) {answers.first}
      let(:access_token) { create(:access_token) }
      before do
        get api_v1_question_answers_path(question),
         as: :json, params: {access_token: access_token.token}
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at rating).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).
            to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/1/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: answer) }

    it_behaves_like 'unauthenticated' do
      let(:request_to_resource) { get api_v1_answer_path(answer), as: :json }
      let(:request_with_invalid_token) { get api_v1_answer_path(answer),
          as: :json, params: { access_token: '12345' } }
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      before do
        file = File.open("#{Rails.root}/spec/spec_helper.rb")
        answer.attachments.create(file: file)
      end
      before { get api_v1_answer_path(answer),
        as: :json, params: {access_token: access_token.token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at rating).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).
            to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      describe 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).
              to be_json_eql(comment.send(attr.to_sym).to_json).
                at_path("answer/comments/0/#{attr}")
          end
        end
      end

      describe 'attachments' do


        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it 'contains url' do
          expect(response.body).
            to be_json_eql(answer.attachments.first.file.url.to_json).
              at_path('answer/attachments/0/url')
        end
      end
    end
  end

  describe 'POST /create' do

    it_behaves_like 'unauthenticated' do
      let(:request_to_resource) { post api_v1_question_answers_path(question), as: :json }
      let(:request_with_invalid_token) { post api_v1_question_answers_path(question),
          as: :json, params: { access_token: '12345' } }
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      let(:params) {
                      {
                        as: :json, params:
                        {
                          access_token: access_token.token,
                          question_id: question,
                          answer: attributes_for(:answer)
                        }
                      }
                    }
                    
      it 'returns 201 status' do
        post api_v1_question_answers_path(question), params
        expect(response.status).to eq 201
      end

      it 'creates new answer' do
        expect { post api_v1_question_answers_path(question), params }
          .to change(question.answers, :count).by(1)
      end

      %w(id body created_at updated_at rating).each do |attr|
        it "answer object contains #{attr}" do
          post api_v1_question_answers_path(question), params
          expect(response.body).
            to be_json_eql(Answer.first.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'with invalid attributes' do
        let(:params) {
                        {
                          as: :json, params:
                          {
                            access_token: access_token.token,
                            question_id: question,
                            answer: { body: nil }
                          }
                        }
                      }

        it 'returns 422 status' do
          post api_v1_question_answers_path(question), params
          expect(response.status).to eq 422
        end

        it 'returns error if body is nil' do
          post api_v1_question_answers_path(question), params
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0/')
        end

        it 'does not create answer in database' do
          expect { post api_v1_question_answers_path(question), params }
            .to_not change(question.answers, :count)
        end
      end
    end
  end
end