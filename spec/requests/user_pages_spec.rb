require 'spec_helper'

describe "User pages" do
  subject { page }

  let(:user) { FactoryGirl.build(:user) }    

  describe "for non-signed in users" do
    describe "signup" do
      let(:submit) { 'Create my account' }

      before { visit signup_path }

      it { should be_on_page full_title('Sign up'), 'Sign up' }

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
        
        before { fill_signup_form user }

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

  describe "for signed in users" do
    before do 
      user.save
      visit signin_path
      sign_in user
    end
      
    describe "show" do
      before { visit user_path(user) }
      it { should be_on_page user.name, user.name }
    end    

    describe "edit" do
      let(:submit) { 'Update' }

      before { visit edit_user_path(user) }

      it { should be_on_page 'Edit profile', 'Update your profile' }
      it { should have_link 'Change picture', href: 'http://www.gravatar.com/emails' }

      describe "with invalid information" do
        before { click_button submit }
        it { should have_content('error') }
      end

      describe "with valid information" do  
        let(:new_user) { FactoryGirl.build(:user, :changed) }

        before do
          fill_signup_form new_user
          click_button submit
        end

        it { should have_selector('title', text: new_user.name) }
        it { should have_success_message "Profile updated" }
        it { should have_link('Sign out', href: signout_path) }
        specify { user.reload.name.should  == new_user.name }
        specify { user.reload.email.should == new_user.email }
      end
    end
  end

end