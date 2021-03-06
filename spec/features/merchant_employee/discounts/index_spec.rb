require 'rails_helper'

RSpec.describe "As an merchant employee", type: :feature do
  describe "when I visit my merchant dashboard page" do
    it "I click button to see a list of my current bulk discounts" do
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
      
      visit "/merchant"

      click_button "My Discounts"

      expect(current_path).to eq("/merchant/discounts")
      
      expect(page).to have_content("My Discount List")
      expect(page).to have_content("#{discount1.name}")
      expect(page).to have_content("#{discount2.name}")
      expect(page).not_to have_content("#{discount3.name}")
    end

  end
end