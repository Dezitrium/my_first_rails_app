require 'spec_helper'

describe "Authentication" do

  let(:user) { FactoryGirl.create(:user) }  

  subject { page }

  describe "signin page" do
    before { visit signin_path }
    let(:submit) { "Sign in" }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: full_title('Sign in')) }

    describe "with valid login data" do
        before do           
          fill_in "Email",      with: user.email
          fill_in "Password",   with: user.password
          click_button submit 
        end

        it { should have_selector('title', text: user.name) }
        it { should have_no_link('Sign in', href: signin_path) } 
        it { should have_link('Profile',  href: user_path(user)) } 
        it { should have_link('Sign out', href: signout_path) } 
    end

    describe "with invalid login data" do
        before do           
          fill_in "Email",      with: user.email
          fill_in "Password",   with: 'a' + user.password
          click_button submit 
        end

        it { should have_selector('title', text: 'Sign in') }
        it { should have_selector('div.alert.alert-error', text: 'Invalid') }

        describe 'after visiting another page' do 
          before { click_link 'Home' }
          it { should have_no_selector('div.alert.alert-error', text: 'Invalid') }          
        end
    end
  end

end
