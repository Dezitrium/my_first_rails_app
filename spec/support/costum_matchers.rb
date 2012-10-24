%w(success error).each do |type|
  RSpec::Matchers.define "have_#{type}_message".to_sym do |message|
    match do |page|
      page.should have_selector("div.alert.alert-#{type}", text: message)
    end
  end

  RSpec::Matchers.define "have_no_#{type}_message".to_sym do |message|
    match do |page|
      page.should have_no_selector("div.alert.alert-#{type}", text: message)
    end
  end
end

RSpec::Matchers.define :be_on_page do |title, h1|
    match do |page|
      page.should have_selector('h1',    text: h1) 
      page.should have_selector('title', text: title)
    end
end
