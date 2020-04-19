require 'rails_helper'

RSpec.describe "As a merchant employee", type: :feature do
  describe "when I visit my discount index page" do
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
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)
    end
    
    
    it "I click button to create new discount, fill in form then see new discount listed" do
      visit merchant_discounts_path
      
      expect(page).to have_content("#{@discount1.name}")

      click_button "Create New Discount"

      expect(current_path).to eq(new_merchant_discount_path)
      expect(page).to have_content("New Discount for Brian's Bike Shop")

      fill_in :name, with: "Buy 20 Get 20% OFF!"
      fill_in :threshold, with: "20"
      fill_in :percent_off, with: "20"

      click_button "Submit"
      
      new_discount = Discount.last
      
      expect(current_path).to eq(merchant_discounts_path)
      expect(page).to have_content("#{@discount1.name}")
      expect(page).to have_content("#{new_discount.name}")
    end
  end
end