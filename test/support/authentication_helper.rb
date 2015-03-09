require "test_helper"

module AuthenticationHelper
  include Capybara::DSL

  def self.included(klass)
    klass.fixtures(:users)
  end

  def login_as_oswald
    user = users(:oswald)
    login_as(user)
  end

  def login_as_weenie
    user = users(:weenie)
    login_as(user)
  end

  def logout!
    visit("/logout")
  end

  private

    def login_as(user)
      visit("/login")
      within("//form") do
        fill_in("username", :with => user.email)
        fill_in("password", :with => "secret")
      end
      click_button("Log in")
    end
end
