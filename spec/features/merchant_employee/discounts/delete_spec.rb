require 'rails_helper'

RSpec.describe "As an merchant employee", type: :feature do
  describe "when I visit my discounts index page" do
    before(:each) do 
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      employee = bike_shop.users.create!(name: "Josh Tukman",
                                        address: "756 Main St",
                                        city: "Denver",
                                        state: "Colorado",
                                        zip: "80210",
                                        email: "josh.t@gmail.com",
                                        password: "secret_password",
                                        password_confirmation: "secret_password",
                                        role: 1)
      @discount1 = bike_shop.discounts.create!(name: "Buy 5 items get 10% OFF", threshold: 5, percent_off: 10)
      @discount2 = bike_shop.discounts.create!(name: "Buy 10 items get 20% OFF", threshold: 10, percent_off: 20)
      # discount3 = dog_shop.discounts.create!(name: "Buy 20 items get 50% OFF", threshold: 20, percent_off: 50)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)
    
      visit merchant_discounts_path
    end
    
    it "I see delete button next to each discount" do
      within "#discount-#{@discount1.id}" do
        expect(page).to have_button("Delete Discount")
      end
      within "#discount-#{@discount2.id}" do
        expect(page).to have_button("Delete Discount")
      end
    end
    
    it "I click a discount's delete button and no longer see it on the page" do
      expect(page).to have_link(@discount1.name)
      expect(page).to have_link(@discount2.name)
      
      within "#discount-#{@discount1.id}" do
        click_button "Delete Discount"
      end
      
      expect(page).not_to have_link(@discount1.name)
      expect(page).to have_link(@discount2.name)
    end
    
    it "I receive confirmation message that discount has been removed" do
      within "#discount-#{@discount1.id}" do
        click_button "Delete Discount"
      end
      
      expect(page).to have_content("Discount has been deleted.")
    end

  end
end