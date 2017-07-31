FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name 'Test'
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    uid '13579ace'
    secret '24680cdf'
  end
end