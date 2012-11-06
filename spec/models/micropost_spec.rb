# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }   
  let(:micropost) { FactoryGirl.build(:micropost, user: user) }  

  subject { micropost }
   
  describe 'Attributes' do
    it { should respond_to :user_id }
    it { should respond_to :content }
  end

  describe 'Class Methods' do
    specify { Micropost.should respond_to :from_users_followed_by }
  end

  describe 'Associations' do
    it { should respond_to :user }  
    its(:user) { should == user }
  end

  describe 'Validation' do
    it { should be_valid }
    
    describe 'for user_id' do
      it 'should be present' do
        micropost.user_id = nil
        should_not be_valid
      end
    end

    describe 'for content' do
      it 'should be present' do
        micropost.content = nil
        should_not be_valid
      end

      it 'should has maximum length' do 
        micropost.content = 'a' * 160
        should be_valid
        micropost.content += 'a'
        should_not be_valid
      end
    end

    describe 'Non accessible attributes' do
      it { should_not allow_mass_assignment_of :user_id }      
    end
  end

end
