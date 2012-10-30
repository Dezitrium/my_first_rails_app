require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "in the Users controller" do
    let!(:user) { FactoryGirl.create(:user) } 
    
    describe "for signin page" do
      before { visit signin_path }

      it { should be_on_page 'Sign in' }

      describe "with valid login data" do
        before { sign_in user }         

        it { should have_selector 'title', text: user.name }

        it { should have_no_link 'Sign in', href: signin_path } 

        it { should have_link 'Users',    href: users_path } 
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

    describe "for non-signed-in users" do
      describe "visiting the edit page" do
        before { visit edit_user_path(user) }

        it { should have_selector('title', text: 'Sign in') }
        it { should have_notice_message 'Please sign in' }

        describe "after signing in" do
          before { sign_in user }

          it "should render requested page (friendly forwarding)" do
            current_path.should == edit_user_path(user)
          end

          describe "and again" do
            before do 
              delete signout_path
              visit signin_path
              sign_in user
            end

            specify { current_path.should == user_path(user) }
          end
        end
      end

      describe 'visiting the followers page' do        
        before { get followers_user_path(user) }

        specify { response.should redirect_to(signin_path) }
      end

      describe 'visiting the following page' do
        before { get following_user_path(user) }

        specify { response.should redirect_to(signin_path) }
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

          it "should render requested page (friendly forwarding)" do
            current_path.should == users_path
          end

          describe "and again" do
            before do 
              delete signout_path
              visit signin_path
              sign_in user
            end

            specify { current_path.should == user_path(user) }
          end
        end
      end
    end

    describe "for signed in users" do
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

      describe "submitting a GET request to the Users#new action"  do
        before { get new_user_path }

        specify { response.should redirect_to(root_path) }
      end

      describe "submitting a POST request to the Users#create action"  do
        before { post users_path }
        
        specify { response.should redirect_to(root_path) }
      end

      describe "submitting a PUT request to the Users#update action"  do
        before { put user_path(other_user) }

        specify { response.should redirect_to(root_path) }
      end

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(other_user) }

        specify { response.should redirect_to(root_path) }        

        it "should not delete user" do
          expect { delete user_path(other_user) }.not_to change(User, :count)
        end
      end
    end

    describe "for admins" do
      let!(:admin) { FactoryGirl.create(:admin) }
      let!(:other_admin) { FactoryGirl.create(:admin) }

      before do 
        visit signin_path
        sign_in admin 
      end

      describe "submitting a DELETE request to the Users#destroy action" do
        it "should delete user" do
          expect { delete user_path(user) }.to change(User, :count).by(-1)
        end        

        it "should not delete admin" do
          expect { delete user_path(other_admin) }.not_to change(User, :count)
        end 
      end
    end
  end

  describe "in the Microposts controller" do
    let!(:micropost) { FactoryGirl.create(:micropost) } 

    describe "for non-signed-in users" do
      describe "submitting a POST request to the Microposts#create action"  do
        before { post microposts_path }

        specify { response.should redirect_to(signin_path) }
      end

      describe "submitting a DELETE request to the Microposts#destroy action"  do
        before { delete micropost_path(micropost) }

        specify { response.should redirect_to(signin_path) }
      end
    end

    describe "for signed in users" do
      before do 
        visit signin_path
        sign_in user 
      end

      let(:other_user) { FactoryGirl.create(:user, name:'User 2') }
    end

    describe "for admins" do
      let!(:admin) { FactoryGirl.create(:admin) }
      let!(:other_admin) { FactoryGirl.create(:admin) }

      before do 
        visit signin_path
        sign_in admin 
      end

    end
  end

end
