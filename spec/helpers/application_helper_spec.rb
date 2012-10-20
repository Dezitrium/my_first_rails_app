require 'spec_helper'

describe ApplicationHelper do

  describe 'full_title' do
    it 'should include the page title' do
      full_title('foo').should match 'foo'
    end

    it 'should include the base title' do
      full_title('foo').should match base_title
    end

    it 'should not include a bar for the home page' do
      full_title('').should == base_title
      full_title(nil).should == base_title
    end

    it 'should not include a bar for the home page' do
      title = full_title(['foo','bar'])
      title.should match 'foo'
      title.should match 'bar'
    end
  end
end