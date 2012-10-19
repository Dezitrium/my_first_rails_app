require 'spec_helper'

describe "StaticPages" do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' } 


  describe "Routing" do  
    it "should receive 200 (OK) Status" do 
      get '/static_pages/home' 	  
      response.status.should be(200)
  	end
  end

  describe "Home page" do
  	before { visit '/static_pages/home' }

    it "should have the heading 'Sample App'" do      
      page.should have_selector('h1', text:'Sample App')
    end

    it "should have the right title" do
      page.should have_selector('title', text:"#{base_title}")
    end
  end

  describe "Help page" do
    before { visit '/static_pages/help' }

    it "should have the heading 'Help'" do      
      page.should have_selector('h1', text:'Help')
    end

    it "should have the right title" do
      page.should have_selector('title', text:"#{base_title} | Help")
    end
  end


  describe "About page" do
    before { visit '/static_pages/about' }

    it "should have the heading 'About Us'" do      
      page.should have_selector('h1', text:'About Us')
    end

    it "should have the right title" do
      page.should have_selector('title', text:"#{base_title} | About")
    end
  end

  describe "Contact page" do
    before { visit '/static_pages/contact' }

    it "should have the heading 'Contact Us'" do      
      page.should have_selector('h1', text:'Contact Us')
    end

    it "should have the right title" do
      page.should have_selector('title', text:"#{base_title} | Contact")
    end
  end

end
