require 'rails_helper'

RSpec.describe "When more than one discount has the same threshold", type: :feature do
  it "the greatest percent off discount is chosen" do
    bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    pedals = bike_shop.items.create(name: "Pedals", description: "Clipless bliss!", price: 200, image: "https://www.rei.com/media/product/130015", inventory: 20)
    employee = bike_shop.users.create!(name: "Josh Tukman",
                                      address: "756 Main St",
                                      city: "Denver",
                                      state: "Colorado",
                                      zip: "80210",
                                      email: "josh.t@gmail.com",
                                      password: "secret_password",
                                      password_confirmation: "secret_password",
                                      role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)

    discount2 = bike_shop.discounts.create!(name: "Buy 5 items get 20% OFF", threshold: 5, percent_off: 20)
    discount3 = bike_shop.discounts.create!(name: "Buy 5 items get 50% OFF", threshold: 5, percent_off: 50)
    discount1 = bike_shop.discounts.create!(name: "Buy 5 items get 10% OFF", threshold: 5, percent_off: 10)
    discount4 = bike_shop.discounts.create!(name: "Buy 10 items get 75% OFF", threshold: 10, percent_off: 75)

    visit item_path(pedals)
    click_button "Add To Cart"

    visit "/cart"
    
    within "#cart-item-#{pedals.id}" do
      4.times do
        click_button "Add Qty"
      end 
      
      expect(page).to have_content("$500.00")
      # expect(page).to have_content("Buy 5 items get 50% OFF")
      expect(page).not_to have_content("$900.00")
      expect(page).not_to have_content("$800.00")
    end
  end

end