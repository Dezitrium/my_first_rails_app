require 'spec_helper'

describe "Authentication" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }  

  describe "signin page" do
    before { visit signin_path }
    
    it { should be_on_page 'Sign in' }

    describe "with valid login data" do
        before { sign_in user }         

        it { should have_selector 'title', text: user.name }

        it { should have_no_link 'Sign in', href: signin_path } 

        it { should have_link 'Users',     href: users_path } 
        it { should have_link 'Profile',  href: user_path(user) } 
        it { should have_link 'Settings', href: edit_user_path(user) } 
        it { should have_link 'Sign out', href: signout_path } 
    end

    describe "with invalid login data" do
        let(:invalid_user) { FactoryGirl.build(:user, :wrong_password) } 

        before { sign_in invalid_user }

        it { should have_selector('title', text: 'Sign in') }
        it { should have_error_message 'Invalid' }

        describe 'after visiting another page' do 
          before { click_link 'Home' }

          it { should have_no_error_message 'Invalid' }
        end
    end
  end

  describe "authorization" do
    describe "in the Users controller" do
      describe "for non-signed-in users" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }

          it { should have_selector('title', text: 'Sign in') }
          it { should have_notice_message 'Please sign in' }

          describe "after signing in" do
            before { sign_in user }
            it "should render the desired protected page" do
              page.should have_selector('title', text: 'Edit profile')
            end
          end
        end

        describe "submitting to the update action" do
          before { put user_path(user) }

          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the users index" do
          before { visit users_path }

          it { should have_selector('title', text: 'Sign in') }
          it { should have_notice_message 'Please sign in' }

          describe "after signing in" do
            before { sign_in user }
            it "should render the desired protected page" do
              page.should have_selector('title', text: 'Users')
            end
          end
        end
      end

      describe "for other signed in users" do
        before do 
          visit signin_path
          sign_in user 
        end

        let(:other_user) { FactoryGirl.create(:user, name:'User 2') }

        describe "visiting the Users#edit page" do
          before { visit edit_user_path(other_user) }

          it { should have_no_selector 'title', text: 'Edit profile' }
          it { should have_notice_message "Can't edit other users" }
        end

        describe "submitting a PUT request to the Users#update action"  do
          before { put user_path(other_user) }

          specify { response.should redirect_to(root_path) }
        end
      end
    end
  end

end
