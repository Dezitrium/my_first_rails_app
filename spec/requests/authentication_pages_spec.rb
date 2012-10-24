require 'spec_helper'

describe "Authentication" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }  

  describe "signin page" do
    let(:submit) { "Sign in" }

    before { visit signin_path }
    
    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: full_title('Sign in')) }

    describe "with valid login data" do
        before do 
          fill_signin_form user: user          
          click_button submit 
        end

        it { should have_selector('title', text: user.name) }
        it { should have_no_link('Sign in', href: signin_path) } 
        it { should have_link('Profile',  href: user_path(user)) } 
        it { should have_link('Sign out', href: signout_path) } 
    end

    describe "with invalid login data" do
        before do  
          fill_signin_form with: { email: user.email, pw: 'a' + user.password }
          click_button submit 
        end

        it { should have_selector('title', text: 'Sign in') }
        it { should have_error_message 'Invalid' }

        describe 'after visiting another page' do 
          before { click_link 'Home' }
          it { should have_no_error_message 'Invalid' }
        end
    end
  end

end
