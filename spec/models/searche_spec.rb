require 'rails_helper'

describe '.execute' do

  let(:query) { '111' }

  %w{questions answers comments users}.each do |type|
    it "should send search message to class" do
      expect(type.capitalize.singularize.constantize).to receive(:search).with(query)
      Search.execute(query, type)
    end
  end

  it 'should send search message to ThinkingSphinx' do
    expect(ThinkingSphinx).to receive(:search).with(query)
    Search.execute(query, 'all')
  end
end