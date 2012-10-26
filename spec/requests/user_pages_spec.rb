require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "for non-signed in users" do
    let(:user) { FactoryGirl.build(:user) }

    describe "signup page" do
      let(:submit) { 'Create my account' }

      before { visit signup_path }

      it { should be_on_page 'Sign up' }
      it { should have_no_links_for_users }

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
    let(:user) { FactoryGirl.create(:user) }  

    before do       
      visit signin_path
      sign_in user
    end
      
    describe "show page" do
      before { visit user_path(user) }
      it { should be_on_page user.name }
    end    

    describe "edit page" do
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

    describe "index page" do
      before { visit users_path }

      it { should be_on_page 'Users' }
      it { should have_no_link('delete') }      

      describe "pagination" do
        before(:all) do 
          User.delete_all
          FactoryGirl.create_list(:user, 15)
        end
        after(:all) { User.delete_all }

        it { should be_pagniated }
        it "should list each user" do
          User.paginate(page: 1, per_page:15).each do |user|
            page.should have_selector('li', text: user.name)
          end
        end
      end  
    end
  end

  describe "for admin users" do
    let(:user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      user.save!
      visit signin_path
      sign_in admin      
    end

    describe "index page" do
      before { visit users_path }

      it { should have_link('delete', href: user_path(user)) }
      it { should have_no_link('delete', href: user_path(admin)) }

      it "should be able to delete another user" do
        expect { click_link('delete') }.to change(User, :count).by(-1)
      end    
    end
  end
end