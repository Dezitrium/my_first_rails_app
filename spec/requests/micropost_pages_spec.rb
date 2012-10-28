require 'spec_helper'

describe "MicropostPages" do
  subject { page }

  describe 'for signed in users' do
    let!(:user) { FactoryGirl.create(:user) }

    before do 
      FactoryGirl.create_list(:micropost, 20, user: user, content: "Foo")
      visit signin_path
      sign_in user
    end

    describe 'on the home page' do
      before { visit root_path }

      describe 'creation' do
        let(:submit) { 'Post' }
        let(:next_page) { 'Next' }

        describe 'with invalid information' do
          it 'should not create a micropost' do
            expect { click_button submit }.not_to change(Micropost, :count)
          end

          
          describe 'after submitting' do
            before { click_button submit }
            
            it { should have_content 'error' }

            describe 'and visit next page' do
              it 'should have no routing error' do
                expect { click_link next_page }.not_to raise_error(ActionController::RoutingError)
              end
            end
          end        
        end

        describe 'with valid information' do
          before { fill_in 'micropost_content', with: 'Lorem Ipsum' }
          
          it 'should create a micropost' do
            expect { click_button submit }.to change(Micropost, :count).by(1)
          end

          describe 'after submitting' do
            before { click_button submit }

            it { should have_success_message 'Micropost created' }
          end
        end
      end

      describe 'deletion' do
        let(:delete) { 'delete' }

        it 'should delete own micropost' do
          expect { click_link delete }.to change(Micropost, :count).by(-1)
        end

        describe 'after submitting' do
          before { click_link delete }

          it { should have_success_message 'Micropost deleted' }
        end
      end
    end
  end
end
