require 'spec_helper'

describe Event do
  let(:user) { FactoryGirl.create(:user) }
  let(:event) { FactoryGirl.build(:event, user: user) }

  subject { event }

  describe 'Attributes' do
    it { should respond_to :user_id }
    it { should respond_to :title }
    it { should respond_to :start_at }
    it { should respond_to :end_at }
    it { should respond_to :recurring_type }
  end

  describe 'Associations' do
    it { should respond_to :user }  
    its(:user) { should == user }
  end

  describe 'Validation' do
    it { should be_valid }
    
    describe 'for user_id' do
      it 'should be present' do
        event.user_id = nil
        should_not be_valid
      end
    end

    describe 'for title' do
      it 'should be present' do
        event.title = nil
        should_not be_valid
      end

      it 'should has maximum length' do
        event.title = 'a' * 160
        should be_valid
        event.title += 'a'
        should_not be_valid
      end
    end

    describe 'for start_at' do
      it 'should be present' do
        event.start_at = nil
        should_not be_valid
      end
    end

    describe 'for end_at' do
      describe 'if present' do

        before { event.end_at = DateTime.now }

        it 'should be after start_at' do
          event.start_at = event.end_at.advance(days: 1)
          should_not be_valid
          event.start_at = event.end_at.advance(days: -1)
          should be_valid
        end
      end
    end

    describe 'for recurring_type' do
      describe 'if not present' do
        describe 'after save' do
          before { event.save! }
          
          its(:recurring_type) { should == "once" }
        end
      end
    end

    describe 'Non accessible attributes' do
      it { should_not allow_mass_assignment_of :user_id }      
    end
  end

end
