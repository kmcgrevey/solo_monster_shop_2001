require 'rails_helper'

RSpec.describe "When I visit my cart as a User", type: :feature do
  before(:each) do
    bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    # dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @pedals = bike_shop.items.create(name: "Pedals", description: "Clipless bliss!", price: 200, image: "https://www.rei.com/media/product/130015", inventory: 20)
    
    employee = bike_shop.users.create!(name: "Josh Tukman",
                                      address: "756 Main St",
                                      city: "Denver",
                                      state: "Colorado",
                                      zip: "80210",
                                      email: "josh.t@gmail.com",
                                      password: "secret_password",
                                      password_confirmation: "secret_password",
                                      role: 1)
      discount2 = bike_shop.discounts.create!(name: "Buy 10 items get 50% OFF", threshold: 10, percent_off: 50)
      discount1 = bike_shop.discounts.create!(name: "Buy 5 items get 10% OFF", threshold: 5, percent_off: 10)
      discount4 = bike_shop.discounts.create!(name: "Buy 11 items get 100% OFF", threshold: 11, percent_off: 100)
    # discount3 = dog_shop.discounts.create!(name: "Buy 20 items get 50% OFF", threshold: 20, percent_off: 50)
    
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)
  end
  
  it "I can select req'd amount of an item to get an initial bulk discount" do
    visit item_path(@pedals)

    click_button "Add To Cart"

    visit "/cart"
    
    within "#cart-item-#{@pedals.id}" do
      click_button "Add Qty"
      
      expect(page).to have_content("$400.00")
      
      3.times do
        click_button "Add Qty"
      end 
      
      expect(page).not_to have_content("$1,000.00")
      expect(page).to have_content("$900.00")
    end

    expect(page).not_to have_content("Total: $1000.00")
    expect(page).to have_content("Total: $900.00")
  end
  
  it "I can select req'd amount of an item to get a larger bulk discount" do
    visit item_path(@pedals)

    click_button "Add To Cart"

    visit "/cart"
    
    within "#cart-item-#{@pedals.id}" do
      click_button "Add Qty"
      
      expect(page).to have_content("$400.00")
      
      8.times do
        click_button "Add Qty"
      end 
      
      expect(page).not_to have_content("$2,000.00")
      expect(page).to have_content("$1,000.00")
    end

    expect(page).not_to have_content("Total: $2,000.00")
    expect(page).to have_content("Total: $1,000.00")

    within "#cart-item-#{@pedals.id}" do
      click_button "Add Qty"

      expect(page).to have_content("$0.00")
    end
    
    expect(page).to have_content("Total: $0.00")
  end
end