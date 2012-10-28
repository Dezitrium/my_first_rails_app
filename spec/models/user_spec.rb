# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#

require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create(:user) }   

  subject { user }
 
  describe 'Attributes' do
    it { should respond_to :name }
    it { should respond_to :email }
    it { should respond_to :admin }
    it { should respond_to :remember_token }
    it { should respond_to :password_digest }
    it { should respond_to :password }
    it { should respond_to :password_confirmation }

    describe 'after save' do
      before { user.save }
      
      its(:admin) { should be_false }   
      its(:remember_token) { should_not be_blank }

      describe 'admin status' do
        before { user.toggle!(:admin) }
    
        it { should be_admin }
      end
    end    

    describe 'Non accessible attributes' do
      it { should_not allow_mass_assignment_of :admin }
      it { should_not allow_mass_assignment_of :remember_token }
    end
  end  

  describe 'Associations' do
    describe 'for microposts' do
      let!(:older_micropost) do 
        FactoryGirl.create(:micropost, user: user, created_at: 2.hours.ago)
      end
  
      let!(:newer_micropost) do 
        FactoryGirl.create(:micropost, user: user, created_at: 1.hour.ago)
      end

      it { should respond_to :microposts }    
      specify { user.microposts.should == [newer_micropost, older_micropost] }

      it "should destroy associated microposts" do
        microposts = user.microposts.dup
        user.destroy
        microposts.should_not be_empty
        microposts.each do |micropost|
          Micropost.find_by_id(micropost.id).should be_nil
        end
      end

      describe "status" do
        let(:unfollowed_post) do
          FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
        end

        its(:feed) { should include(newer_micropost) }
        its(:feed) { should include(older_micropost) }
        its(:feed) { should_not include(unfollowed_post) }
      end
    end
  end

  describe 'Methods' do
    it { should respond_to :feed }
    it { should respond_to :authenticate }
  end

  describe 'Validation' do
    it { should be_valid }

    describe 'for name' do
      it 'when is empty' do 
        user.name = ' '
        should_not be_valid
      end

      it 'should has maximum length' do 
        user.name = 'a' * 50
        should be_valid
        user.name += 'a'
        should_not be_valid
      end
    end

    describe 'for email' do
      it 'when is empty' do 
        user.email = ' '
        should_not be_valid
      end

      it 'should be unique' do 
        duplicate_user = user.dup
        duplicate_user.save
        duplicate_user.should_not be_valid
      end

      it 'should be unique (case insensitive)' do 
        duplicate_user = user.dup
        duplicate_user.email.upcase!
        duplicate_user.save
        duplicate_user.should_not be_valid
      end

      it 'when is a valid address' do 
        VALID_EMAILS.each do |valid_email|
          user.email = valid_email
          should be_valid          
        end        
      end

      it 'when is a invalid address' do
        INVALID_EMAILS.each do |invalid_email|
          user.email = invalid_email
          should_not be_valid          
        end
      end

      it 'should be saved in downcase' do
        mixed_case_email = 'eXaMpLe@tEsT.COM'
        user.email = mixed_case_email
        user.save
        user.reload.email.should == mixed_case_email.downcase
      end

    end

    describe 'for password' do
      it 'when is empty' do 
        user.password = user.password_confirmation = ' '
        should_not be_valid
      end

      it 'when password and confirmation dont match' do
        user.password_confirmation = 'wrong password'
        should_not be_valid
      end

      it 'should has minimum length' do 
        user.password = user.password_confirmation = ''

        8.times do
          should_not be_valid
          user.password_confirmation = (user.password << 'a')
        end

        should be_valid
      end
    end

    describe 'return value of authenticate method' do
      before { user.save }
      let(:found_user) { User.find_by_email(user.email) }

      describe 'with valid password' do
        it { should == found_user.try(:authenticate, user.password) }
      end

      describe 'with invalid password' do
        let(:user_with_invalid_password) do
          found_user.authenticate('invalid')
        end

        it { should_not == user_with_invalid_password }
        specify { user_with_invalid_password.should be_false }
      end
    end
  end

end
