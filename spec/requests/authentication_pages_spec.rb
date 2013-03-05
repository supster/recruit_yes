require 'spec_helper'

describe "Authentication" do
  
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
  
    it { should have_selector('h1',     text: 'Sign In') }
    it { should have_selector('title',  text: full_title('Sign In'))}

  end
  
  describe "signin" do
    before { visit signin_path }
    
      describe "with invalid information" do
        before { click_button "Sign in" }
      end
  end
  
  describe "autherization" do
      describe "for non-signed-in users" do
        
        #describe "visiting the edit page" do
        #  before {visit edit_user_path(user)}
        #  it { should have_selector("Sign In") }
        #end
        
        
      end
      
    
  end
end
