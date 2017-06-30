require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question)}
  it { should belong_to(:user) }
  it { should validate_presence_of :body}
  it { should have_db_index(:question_id) }

  let(:question) { create(:question_with_answers) }
  let(:answer) { question.answers.first }
  let(:new_best_answer) { question.answers.last }

  describe '#set_best' do
    before do
      answer.select_best
    end
    it 'should set best answer' do
      answer.reload
      expect(answer.best).to be_truthy
    end

    it 'should remove best mark from old best answer' do
      new_best_answer.select_best
      answer.reload
      expect(answer.best).to be_falsey
    end
  end
end
