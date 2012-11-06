require 'spec_helper'

describe 'User pages' do
  subject { page }

  describe 'for non-signed in users' do
    let(:user) { FactoryGirl.build(:user) }

    describe 'signup page' do
      let(:submit) { 'Create my account' }

      before { visit signup_path }

      it { should be_on_page 'Sign up' }
      it { should have_no_links_for_users }

      describe 'with invalid information' do
        it 'should not create a user' do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe 'after submission' do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end

      describe 'with valid information' do
        
        before { fill_signup_form user }

        it 'should create a user' do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        describe 'after saving the user' do
          let(:found_user) { User.find_by_email(user.email) }

          before { click_button submit }
          
          it { should have_selector('title', text: found_user.name) }
          it { should have_success_message 'Welcome' }
          it { should have_link 'Sign out' }

          describe 'followed by sign out' do
            before { click_link 'Sign out' }         
            it { should have_link 'Sign in' }
            it { should have_success_message 'Bye bye' }
          end
        end
      end
    end
  end

  describe 'for signed in users' do
    let(:user) { FactoryGirl.create(:user) }
    let(:follower) { FactoryGirl.create(:user) }  
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before do       
      visit signin_path
      sign_in user
    end

    describe 'users home page' do
      before { visit root_path }      

      describe 'feed' do
        it "should render the user's feed" do
          user.feed.each do |item| 
            page.should have_selector "li##{item.id}", text: item.content
          end
        end

        describe 'pagination' do
          pending 'write paginations tests'                       
        end
      end

      describe 'following/followers counts' do
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("0 followers", href: followers_user_path(user)) }

        describe 'with one each' do
          let(:other_user) { FactoryGirl.create(:user) }

          before do
            user.follow! other_user
            other_user.follow! user
            visit root_path
          end

          it { should have_link("1 following", href: following_user_path(user)) }
          it { should have_link("1 follower", href: followers_user_path(user)) }

          describe 'at following page' do
            before { visit following_user_path(user) }

            it { should be_on_page 'Following', user.name }
            it { should have_selector 'h3', text: 'Following' }
            it { should have_link(other_user.name, href: user_path(other_user)) }
          end

          describe 'at followers page' do
            before { visit followers_user_path(other_user) }

            it { should be_on_page 'Followers', other_user.name }
            it { should have_selector 'h3', text: 'Followers' }
            it { should have_link(user.name, href: user_path(user)) }
          end
        end

        describe 'with more than one for each' do
          let(:other_users) { FactoryGirl.create_list(:user, 5) }

          before do
            other_users.each { |followed| user.follow! followed }
            other_users.each { |follower| follower.follow! user }
            visit root_path
          end

          it { should have_link("5 following", href: following_user_path(user)) }
          it { should have_link("5 followers", href: followers_user_path(user)) }
        end
      end
    end 
      
    describe 'profile page' do
      before { visit user_path(user) }      

      it { should be_on_page user.name }

      describe 'microposts' do
        it { should have_content m1.content }
        it { should have_content m2.content }
        it { should have_content 'Microposts (' + user.microposts.count.to_s + ')' }
      end

      describe 'follow/infollow buttons' do
        let(:other_user) { FactoryGirl.create(:user) }        

        before { visit user_path(other_user) }

        let(:follow) { 'Follow' }
        let(:unfollow) { 'Unfollow' }

        describe 'following' do
          it 'should increment followers count' do
            expect { click_button follow }.to change(other_user.followers, :count).by(1)
          end

          it 'should increment following count' do
            expect { click_button follow }.to change(user.followed_users, :count).by(1)
          end

          describe "toggle button" do
            before { click_button follow }

            it { should have_no_button follow }
            it { should have_button unfollow }
          end
        end

        describe 'unfollowing' do
          before do 
            user.follow! other_user
            visit user_path(other_user)
          end

          it 'should decrease followers count' do
            expect { click_button unfollow }.to change(other_user.followers, :count).by(-1)
          end

          it 'should decrease following count' do
            expect { click_button unfollow }.to change(user.followed_users, :count).by(-1)
          end

          describe "toggle button" do
            before { click_button unfollow }

            it { should have_no_button unfollow }
            it { should have_button follow }
          end
        end
      end
    end    

    describe 'edit page' do
      let(:submit) { 'Update' }

      before { visit edit_user_path(user) }

      it { should be_on_page 'Edit profile', 'Update your profile' }
      it { should have_link 'Change picture', href: 'http://www.gravatar.com/emails' }

      describe 'with invalid information' do
        before { click_button submit }
        it { should have_content('error') }
      end

      describe 'with valid information' do  
        let(:new_user) { FactoryGirl.build(:user, :changed) }

        before do
          fill_signup_form new_user
          click_button submit
        end

        it { should have_selector('title', text: new_user.name) }
        it { should have_success_message 'Profile updated' }
        it { should have_link('Sign out', href: signout_path) }
        specify { user.reload.name.should  == new_user.name }
        specify { user.reload.email.should == new_user.email }
      end
    end

    describe 'index page' do
      before { visit users_path }

      it { should be_on_page 'Users' }
      it { should have_no_link('delete') }      

      describe 'pagination' do
        before(:all) do 
          User.delete_all
          FactoryGirl.create_list(:user, 15)
        end
        after(:all) { User.delete_all }

        it { should be_pagniated }
        it 'should list each user' do
          User.paginate(page: 1, per_page:15).each do |user|
            page.should have_selector('li', text: user.name)
          end
        end
      end  
    end
  end

  describe 'for admin users' do
    let!(:user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }
    let!(:other_admin) { FactoryGirl.create(:admin) }

    before do
      visit signin_path
      sign_in admin      
    end

    describe 'index page' do
      before { visit users_path }

      let(:delete) { 'delete' }

      it { should have_link delete, href: user_path(user) }

      it { should have_no_link delete, href: user_path(admin) }
      it { should have_no_link delete, href: user_path(other_admin) }

      it 'should be able to delete another user' do
        expect { click_link delete }.to change(User, :count).by(-1)
      end 
    end
  end
end
