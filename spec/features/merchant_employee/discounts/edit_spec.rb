require 'rails_helper'

RSpec.describe "As an merchant employee", type: :feature do
  describe "when I visit a discount show page" do
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
    
    it "I click button to edit the current discount and return after completing edit" do
      visit merchant_discount_path(@discount1)
    
      click_button "Edit Discount"

      expect(current_path).to eq(edit_merchant_discount_path(@discount1))
      
      expect(page).to have_content("Edit This Discount")
      expect(find_field("Name").value).to eq("#{@discount1.name}")
      expect(find_field("Threshold").value).to eq("#{@discount1.threshold}")
      expect(find_field("Percent off").value).to eq("#{@discount1.percent_off}")
      
      fill_in "Name", with: "This is a Test"
      fill_in "Threshold", with: "1"

      click_button "Update Discount"

      expect(current_path).to eq(merchant_discount_path(@discount1))
      
      expect(page).to have_content("This is a Test")
      expect(page).to have_content("Minimum Item Count to Qualify: 1")
      expect(page).to have_content("Discount Percentage: 10%")
      expect(page).not_to have_content("Buy 5 items get 10% OFF")
      expect(page).not_to have_content("Minimum Item Count to Qualify: 5")
    end

    it "I get confirmation message upon successfully updating discount information" do
      visit edit_merchant_discount_path(@discount1)
      
      fill_in "Name", with: "This is a Test"
      fill_in "Threshold", with: "1"

      click_button "Update Discount"

      expect(current_path).to eq(merchant_discount_path(@discount1))
      expect(page).to have_content("Discount information has been updated!")
    end
    
    it "I get error message after entering bad or missing information" do
      visit edit_merchant_discount_path(@discount1)
      
      fill_in "Name", with: nil
      fill_in "Threshold", with: nil
      fill_in "Percent off", with: "120"

      click_button "Update Discount"

      error = "Name can't be blank, Threshold can't be blank, Threshold is not a number, and Percent off must be less than or equal to 100"
      expect(page).to have_content(error)
    end
  
  end
end