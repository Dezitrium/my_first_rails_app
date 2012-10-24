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
#

require 'spec_helper'

describe User do

  before do @user = User.new(name: "Example User", 
                            email: "user@example.com",
                            password: "12345678", 
                            password_confirmation: "12345678")
  end

  subject { @user }

  it { should respond_to :authenticate }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :remember_token }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }

  describe 'remember token' do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe 'Validation' do
    it { should be_valid }

    describe "for name" do
      it 'when is empty' do 
        @user.name = ' '
        should_not be_valid
      end

      it 'should has maximum length' do 
        @user.name = 'a' * 50
        should be_valid
        @user.name += 'a'
        should_not be_valid
      end
    end

    describe "for email" do
      it 'when is empty' do 
        @user.email = ' '
        should_not be_valid
      end

      it 'should be unique' do 
        duplicate_user = @user.dup
        duplicate_user.save
        should_not be_valid
      end

      it 'should be unique (case insensitive)' do 
        duplicate_user = @user.dup
        duplicate_user.email.upcase!
        duplicate_user.save
        should_not be_valid
      end

      it 'when is a valid address' do 
        %w(test@test.de TEST@TEST.de 
          user@foo.COM user_name@foo.COM 
          A_US-ER@f.b.org frst.lst@foo.jp 
          a+b@baz.cn).each do |valid_email|
          @user.email = valid_email
          should be_valid          
        end        
      end

      it 'when is a invalid address' do
        %w(test test@test@de
         user@foo,com user_at_foo.org 
         example.user@foo. foo@bar_baz.com 
         foo@bar+baz.com).each do |invalid_email|
          @user.email = invalid_email
          should_not be_valid          
        end
      end

      it 'should be saved in downcase' do
        mixed_case_email = 'eXaMpLe@tEsT.COM'
        @user.email = mixed_case_email
        @user.save
        @user.reload.email.should == mixed_case_email.downcase
      end

    end

    describe "for password" do
      it 'when is empty' do 
        @user.password = @user.password_confirmation = ' '
        should_not be_valid
      end

      it 'when password and confirmation dont match' do
        @user.password_confirmation = 'wrong password'
        should_not be_valid
      end

      it 'should has minimum length (8 characters)' do 
        @user.password = @user.password_confirmation = ''

        8.times do
          should_not be_valid
          @user.password_confirmation = (@user.password << 'a')
        end

        should be_valid
      end
    end

    describe "return value of authenticate method" do
      before { @user.save }
      let(:found_user) { User.find_by_email(@user.email) }

      describe "with valid password" do
        p @found_user
        it { should == found_user.try(:authenticate, @user.password) }
      end

      describe "with invalid password" do
        let(:user_with_invalid_password) do
          found_user.authenticate("invalid")
        end

        it { should_not == user_with_invalid_password }
        specify { user_with_invalid_password.should be_false }
      end
    end

  end
end
