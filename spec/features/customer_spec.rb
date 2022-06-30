require "rails_helper"

RSpec.feature "Customers", type: :feature do
  scenario "Verifica Link Cadastro de Cliente" do
    visit(root_path)
    expect(page).to have_link("Cadastro de Cliente")
  end

  scenario "verifica link de Novo Cliente" do
    visit(root_path)
    click_on("Cadastro de Clientes")
    expect(page).to have_content("Listando Clientes")
    expect(page).to have_link("Novo Cliente")
  end

  scenario "verifica formulário de novo cliente" do
    visit(customers_path)
    click_on("Novo Cliente")
    expect(page).to have_content("Novo Cliente")
  end

  scenario "cadastra um cliente válido" do
    visit(new_customer_path)
    customer_name = Faker::Name.name
    fill_in("Nome", with: customer_name)
    fill_in("Email", with: Faker::Internet.email)
    fill_in("Telefone", with: Faker::PhoneNumber.phone_number)
    attach_file("Foto do Perfil", "spec/fixtures/avatar.png")
    choose(option: ["S", "N"].sample)
    click_on("Criar Cliente")

    expect(page).to have_content("Cliente cadastrado com sucesso")
    expect(Customer.last.name).to eq(customer_name)
  end

  scenario "Não cadastra um clente invalido" do
    visit(new_customer_path)
    choose(option: ["S", "N"].sample)
    click_on("Criar Cliente")
    expect(page).to have_content("não pode ficar em branco")
  end

  scenario "Mostra um cliente" do
    customer = Customer.create!(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      phone: Faker::PhoneNumber.phone_number,
      smoker: ["S", "N"].sample,
      avatar: "#{Rails.root}/spec/fixtures/avatar.png",
    )

    visit(customer_path(customer.id))
    expect(page).to have_content(customer.name)
  end

  scenario "Testando a Index" do
    customer1 = Customer.create!(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      phone: Faker::PhoneNumber.phone_number,
      smoker: ["S", "N"].sample,
      avatar: "#{Rails.root}/spec/fixtures/avatar.png",
    )
    customer2 = Customer.create!(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      phone: Faker::PhoneNumber.phone_number,
      smoker: ["S", "N"].sample,
      avatar: "#{Rails.root}/spec/fixtures/avatar.png",
    )

    visit(customers_path)
    expect(page).to have_content(customer1.name).and have_content(customer2.name)
  end
end
