require "rails_helper"

feature "Customers", type: :feature do
  scenario "verificar formulário de novo cliente" do
    visit(new_customer_path)
    customer_name = Faker::Name.name
    fill_in("customer_name", with: customer_name)
    fill_in("customer_email", with: Faker::Internet.email)
    fill_in("customer_phone", with: Faker::PhoneNumber.phone_number)
    attach_file("customer_avatar", "#{Rails.root}/spec/fixture/avatar.jpeg")
    choose(option: ["S", "N"].sample)
    click_on("Criar Cliente")
    expect(page).to have_content("Cliente cadastrado com sucesso")
    expect(Customer.last.name).to eq(customer_name)
  end
end
