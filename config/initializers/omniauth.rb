Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, '77xzjs5aalv3xn', 'ragr6wYm7k31RvZu',
           :scope => 'r_basicprofile r_emailaddress',
            :fields => ['id', 'email-address', 'first-name', 'last-name', 'headline', 'industry', 'picture-url', 'public-profile-url', 'location', 'summary']

  OmniAuth.config.on_failure = Proc.new do |env|
    StaticPagesController.action(:home).call(env)
  end

end

