require 'spec_helper'

describe "MicropostPages" do
  subject { page }

  describe 'for signed in users' do
    let!(:user) { FactoryGirl.create(:user) }

    before do 
      visit signin_path
      sign_in user
    end

    describe 'micropost creation' do
      before { visit root_path }

      let(:submit) { 'Post' }

      describe 'with invalid information' do
        it 'should not create a micropost' do
          expect { click_button submit }.not_to change(Micropost, :count)
        end

        
        describe 'after submitting' do
          before { click_button submit }
          
          it { should have_content 'error' }

          describe 'and next page' do
            pending 'should have no routing error'
          end
        end        
      end

      describe 'with valid information' do
        before { fill_in 'micropost_content', with: 'Lorem Ipsum' }
        
        it 'should create a micropost' do
          expect { click_button submit }.to change(Micropost, :count).by(1)
        end
      end
    end
  end
end
