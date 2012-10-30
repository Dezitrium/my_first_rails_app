require 'spec_helper'

describe Relationship do
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) do 
    follower.relationships.build(followed_id: followed.id)
  end

  subject { relationship }

  describe 'Attributes' do
    it { should respond_to :follower }
    it { should respond_to :followed }
    its(:follower) { should == follower }
    its(:followed) { should == followed }

    describe 'Non accessible attributes' do
      it { should_not allow_mass_assignment_of :follower_id }
    end    
  end

  describe 'Validation' do
    it { should be_valid }
    
    describe 'for follower_id' do
      it 'when is empty' do 
        relationship.follower_id = nil
        should_not be_valid
      end
    end

    describe 'for followed_id' do
      it 'when is empty' do 
        relationship.followed_id = nil
        should_not be_valid
      end
    end
  end

end
