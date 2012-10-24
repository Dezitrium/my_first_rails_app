require 'spec_helper'

describe "User pages" do
  subject { page }

  let(:user) { FactoryGirl.build(:user) }    

  describe "signup page" do
    before { visit signup_path }
    it { should be_on_page full_title('Sign up'), 'Sign up' }
  end

  describe "profile page" do    
    before do 
      user.save 
      visit user_path(user)
    end

    it { should be_on_page user.name, user.name }
  end

  describe "signup" do
    let(:submit) { "Create my account" }

    before { visit signup_path }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      
      before { fill_signup_page user }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        let(:found_user) { User.find_by_email(user.email) }

        before { click_button submit }
        
        it { should have_selector('title', text: found_user.name) }
        it { should have_success_message 'Welcome' }
        it { should have_link 'Sign out' }

        describe "followed by sign out" do
          before { click_link 'Sign out' }         
          it { should have_link 'Sign in' }
          it { should have_success_message 'Bye bye' }
        end
      end
    end
  end

end