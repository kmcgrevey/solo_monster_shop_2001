require 'rails_helper'

RSpec.describe "As an merchant employee", type: :feature do
  describe "when I visit my discount index page" do
    it "I click any discounts name to see its show page" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      employee = bike_shop.users.create!(name: "Josh Tukman",
                                        address: "756 Main St",
                                        city: "Denver",
                                        state: "Colorado",
                                        zip: "80210",
                                        email: "josh.t@gmail.com",
                                        password: "secret_password",
                                        password_confirmation: "secret_password",
                                        role: 1)
      discount1 = bike_shop.discounts.create!(name: "Buy 5 items get 10% OFF", threshold: 5, percent_off: 10)
      discount2 = bike_shop.discounts.create!(name: "Buy 10 items get 20% OFF", threshold: 10, percent_off: 20)
      discount3 = dog_shop.discounts.create!(name: "Buy 20 items get 50% OFF", threshold: 20, percent_off: 50)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)
      
      visit merchant_discounts_path

      expect(page).to have_link discount1.name
      expect(page).not_to have_link discount3.name

      click_link discount2.name
      
      expect(current_path).to eq(merchant_discount_path(discount2))
      expect(page).not_to have_content(discount1.name)
      expect(page).not_to have_content(discount3.name)
      expect(page).to have_content(discount2.name)
      expect(page).to have_content("Minimum Item Count to Qualify: 10")
      expect(page).to have_content("Discount Percentage: 20%")
    end

    it "I can return here by clicking link on a discount's show page" do
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
      discount1 = bike_shop.discounts.create!(name: "Buy 5 items get 10% OFF", threshold: 5, percent_off: 10)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)
                              
      visit merchant_discount_path(discount1)

      click_link "Return to Discounts Index"

      expect(current_path).to eq(merchant_discounts_path)
    
    end
  end
end