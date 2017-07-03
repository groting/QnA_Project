require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question)}
  it { should belong_to(:user) }
  it { should validate_presence_of :body}
  it { should have_db_index(:question_id) }

  let(:question) { create :question }
  let!(:current_best) { create :best_answer, question: question }
  let!(:new_best) { create :answer, question: question }

  describe '#select_best' do
    before do
      new_best.select_best
    end

    it 'should set best answer' do
      expect(new_best).to be_best
    end

    it 'should remove best mark from old best answer' do
      current_best.reload
      expect(current_best).to_not be_best
    end
  end
end
