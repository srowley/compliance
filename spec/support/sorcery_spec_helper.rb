# login_user for feature specs
# thanks https://gist.github.com/austenito/2359120
module Sorcery
  module TestHelpers
    module Rails
      def login_user_post(user, password)
        page.driver.post(sessions_url, { username: user, password: password}) 
      end
      
      def logout_user_get
        page.driver.get(logout_url)
      end
    end
  end
end