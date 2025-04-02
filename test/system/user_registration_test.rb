require "application_system_test_case"

class UserRegistrationTest < ApplicationSystemTestCase
  setup do
    @enterprise = Enterprise.create!(
      name: "Test Entreprise",
      address: "123 rue Test"
    )
  end

  test "creating a new manager account" do
    visit new_user_registration_path

    # Remplir le formulaire d'inscription
    fill_in "Prénom", with: "Jean"
    fill_in "Nom", with: "Dupont"
    fill_in "Email", with: "jean.dupont@example.com"
    fill_in "Service", with: "Direction"
    select "Manager", from: "Rôle"
    select "Test Entreprise", from: "Entreprise existante"
    
    # Remplir les informations de l'entreprise
    fill_in "Mot de passe", with: "password123"
    fill_in "Confirmation du mot de passe", with: "password123"

    # Soumettre le formulaire
    click_button "Créer un compte"

    # Vérifier que l'inscription a réussi
    assert_text "Bienvenue ! Vous vous êtes inscrit avec succès."
    
    # Vérifier que le rôle est bien défini
    user = User.last
    assert_equal "manager", user.role
  end

  teardown do
    @enterprise.destroy if @enterprise
  end
end 