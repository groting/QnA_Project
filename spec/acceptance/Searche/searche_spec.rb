require_relative '../acceptance_helper'


RSpec.configure do |config|
  config.before(:suite) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end
end

feature 'Search', %q{
  In order to find an object,
  I need to be able to search it
} do


  given!(:question) { create(:question, title: 'search_string') }
  given!(:answer) { create(:answer, body: 'search_string') }
  given!(:comment) { create(:comment, commentable: question,
    body: 'search_string') }
  given!(:user) { create(:user, email: 'search_string@test.com') }

  background do
    index
    visit root_path
  end

  scenario 'User tries to search question title in all region', js: true do
    fill_in 'Search', with: 'search_string'
    select('all', from: 'resource')
    click_on 'Find'

    expect(page).to have_link 'search_string', href: question_path(question)
    expect(page).to have_link 'search_string', href: answer_path(answer)
    expect(page).to have_link 'search_string', href: comment_path(comment)
    expect(page).to have_content 'search_string@test.com'
  end

  scenario 'User tries to search question title in question region', js: true do
    fill_in 'Search', with: 'search_string'
    select('questions', from: 'resource')
    click_on 'Find'

    expect(page).to have_link 'search_string', href: question_path(question)
    expect(page).to_not have_link 'search_string', href: answer_path(answer)
    expect(page).to_not have_link 'search_string', href: comment_path(comment)
    expect(page).to_not have_content 'search_string@test.com'
  end

  scenario 'User tries to search answer body in answers region', js: true do
    fill_in 'Search', with: 'search_string'
    select('answers', from: 'resource')
    click_on 'Find'

    expect(page).to_not have_link 'search_string', href: question_path(question)
    expect(page).to have_link 'search_string', href: answer_path(answer)
    expect(page).to_not have_link 'search_string', href: comment_path(comment)
    expect(page).to_not have_content 'search_string@test.com'
  end

  scenario 'User tries to search comment body in comments region', js: true do
    fill_in 'Search', with: 'search_string'
    select('comments', from: 'resource')
    click_on 'Find'

    expect(page).to_not have_link 'search_string', href: question_path(question)
    expect(page).to_not have_link 'search_string', href: answer_path(answer)
    expect(page).to have_link 'search_string', href: comment_path(comment)
    expect(page).to_not have_content 'search_string@test.com'
  end

  scenario 'User tries to search user email in users region', js: true do
    fill_in 'Search', with: 'search_string'
    select('users', from: 'resource')
    click_on 'Find'

    expect(page).to_not have_link 'search_string', href: question_path(question)
    expect(page).to_not have_link 'search_string', href: answer_path(answer)
    expect(page).to_not have_link 'search_string', href: comment_path(comment)
    expect(page).to have_content 'search_string@test.com'
  end

  def index
    ThinkingSphinx::Test.index
    sleep 0.25 until index_finished?
  end

  def index_finished?
    Dir[Rails.root.join(ThinkingSphinx::Test.config.indices_location, '*.{new,tmp}*')].empty?
  end
end