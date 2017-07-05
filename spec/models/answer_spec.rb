require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question)}
  it { should belong_to(:user) }
  it { should have_many :attachments }
  it { should validate_presence_of :body}
  it { should have_db_index(:question_id) }
  it { should accept_nested_attributes_for :attachments }

  describe '#select_best' do

    let(:question) { create :question }
    let!(:current_best) { create :best_answer, question: question }
    let!(:new_best) { create :answer, question: question }
    
    before do
      new_best.select_best
    end

    it 'set best answer' do
      expect(new_best).to be_best
    end

    it 'remove best mark from old best answer' do
      current_best.reload
      expect(current_best).to_not be_best
    end
  end
end
