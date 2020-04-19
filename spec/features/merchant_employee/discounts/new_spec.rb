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
      expect(page).to have_content("Create New Discount for Brian's Bike Shop")
      
      fill_in "Name", with: "Buy 20 Get 20% OFF!"
      fill_in "Threshold", with: "20"
      fill_in "Percent off", with: "20"

      click_button "Create Discount"
      
      new_discount = Discount.last
      
      expect(current_path).to eq(merchant_discounts_path)
      expect(page).to have_content("#{@discount1.name}")
      expect(page).to have_content("#{new_discount.name}")
    end

    it "I see success message upon creating a new discount" do
      visit new_merchant_discount_path

      fill_in "Name", with: "Buy 20 Get 20% OFF!"
      fill_in "Threshold", with: "20"
      fill_in "Percent off", with: "20"

      click_button "Create Discount"

      expect(page).to have_content("Your new discount has been added.")
    end

    it "I get an alert for incorrect or missing information" do
      visit new_merchant_discount_path

      fill_in "Name", with: nil
      fill_in "Threshold", with: "w"
      fill_in "Percent off", with: "120"

      click_button "Create Discount"

      flash_error = "Name can't be blank, Threshold is not a number, and Percent off must be less than or equal to 100"
      
      expect(page).to have_content(flash_error)
      expect(page).to have_button("Create Discount")
    end
  
  end
end