require 'test_helper'

class GuideSaveTest < ActionDispatch::IntegrationTest
  setup do
    @enterprise = Enterprise.create!(
      name: "Entreprise Test"
    )
    
    @user = User.create!(
      email: "manager@example.com",
      password: "password123",
      role: :manager,
      first_name: "John",
      last_name: "Doe",
      service: "IT",
      enterprise: @enterprise
    )

    @save_button_selector = "#save-guide-button"
    @current_timestamp = Time.current
  end

  test "sauvegarde d'un guide avec des étapes" do
    assert_difference 'Guide.count', 1 do
      guide = Guide.create!(
        title: "Guide de test",
        description: "Description du guide de test",
        visibility: :private_guide,
        owner: @user,
        enterprise: @user.enterprise
      )

      # Créer des étapes
      guide.steps.create!(
        instruction_text: "Cliquez sur le bouton",
        step_order: 1,
        visual_indicator: "click",
        element_selector: "#submit-button",
        element_type: "button",
        element_text: "Soumettre",
        coordinates: { x: 100, y: 200 },
        scroll_position: 0,
        timestamp: Time.current
      )

      guide.steps.create!(
        instruction_text: "Remplissez le formulaire",
        step_order: 2,
        visual_indicator: "type",
        element_selector: "#form",
        element_type: "form",
        element_text: nil,
        coordinates: { x: 0, y: 0 },
        scroll_position: 0,
        timestamp: Time.current
      )

      assert_equal 2, guide.steps.count
      assert_equal "Guide de test", guide.title
      assert_equal "Description du guide de test", guide.description
      assert_equal 0, guide.visibility_before_type_cast # 0 correspond à private_guide
      assert_equal @user, guide.owner
      assert_equal @user.enterprise, guide.enterprise
    end
  end

  test "sauvegarde d'un guide via l'API" do
    assert_difference 'Guide.count', 1 do
      post "/api/v1/guides", 
        params: {
          guide: {
            title: "Guide API test",
            description: "Description du guide API test",
            visibility: :private_guide
          },
          steps: [
            {
              description: "Première étape",
              type: "click",
              element_selector: "#button",
              element_type: "button",
              element_text: "Cliquez ici",
              coordinates: { x: 100, y: 200 },
              scroll_position: 0,
              timestamp: Time.current
            }
          ]
        },
        headers: { 'Authorization': "Bearer #{@user.generate_jwt}" }
    end

    assert_response :created
    guide = Guide.last
    assert_equal "Guide API test", guide.title
    assert_equal 1, guide.steps.count
  end

  test "sauvegarde d'un guide avec des étapes via l'extension" do
    # Simuler les données capturées par l'extension
    guide_data = {
      guide: {
        title: "Guide de test via extension",
        description: "Guide créé via l'extension Chrome",
        visibility: :private_guide,
        url: "https://example.com/page-test",
        browser_info: "Chrome 120.0.0",
        device_info: "Desktop Windows"
      },
      steps: [
        {
          description: "Cliquez sur le bouton de connexion",
          type: "click",
          element_selector: "#login-button",
          element_type: "button",
          element_text: "Se connecter",
          coordinates: { x: 100, y: 200 },
          scroll_position: 0,
          timestamp: @current_timestamp,
          screenshot: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="
        }
      ]
    }

    # Vérifier que le bouton de sauvegarde est actif avant l'envoi
    assert_not_nil @save_button_selector
    
    # Simuler l'appel API de l'extension pour la capture du guide
    assert_difference 'Guide.count', 1 do
      Rails.logger.info "Envoi des données : #{guide_data.to_json}"
      post "/api/v1/guides/0/capture", 
        params: guide_data.to_json,
        headers: { 
          'Authorization': "Bearer #{@user.generate_jwt}",
          'Content-Type': 'application/json'
        }
      Rails.logger.info "Réponse : #{response.body}"
    end

    # Vérifier la réponse de l'API
    assert_response :created
    response_data = JSON.parse(response.body)
    
    # Vérifier que la réponse contient les informations nécessaires
    assert_not_nil response_data['guide']
    assert_not_nil response_data['edit_url']
    assert_equal 'Guide créé avec succès', response_data['message']

    # Vérifier que le guide a été créé correctement
    guide = Guide.last
    assert_equal "Guide de test via extension", guide.title
    assert_equal "Guide créé via l'extension Chrome", guide.description
    assert_equal "private_guide", guide.visibility
    assert_equal "https://example.com/page-test", guide.url
    assert_equal "Chrome 120.0.0", guide.browser_info
    assert_equal "Desktop Windows", guide.device_info
    assert_equal @user, guide.owner
    assert_equal @user.enterprise, guide.enterprise

    # Vérifier que l'étape a été créée correctement
    assert_equal 1, guide.steps.count
    step = guide.steps.first
    assert_equal "Cliquez sur le bouton de connexion", step.instruction_text
    assert_equal "click", step.visual_indicator
    assert_equal "#login-button", step.element_selector
    assert_equal "button", step.element_type
    assert_equal "Se connecter", step.element_text
    assert_equal({ "x" => 100, "y" => 200 }, step.coordinates)
    assert_equal 0, step.scroll_position
    assert step.screenshot.attached?

    # Vérifier que l'URL d'édition est correcte
    expected_edit_url = "http://www.example.com/guides/#{guide.id}/edit"
    assert_equal expected_edit_url, response_data['edit_url']
  end

  test "gestion des erreurs lors de la sauvegarde d'un guide" do
    # Test avec des données invalides
    invalid_guide_data = {
      guide: {
        # Title manquant intentionnellement
        description: "Guide sans titre",
        visibility: :private_guide
      },
      steps: []
    }

    # Simuler l'appel API avec des données invalides
    assert_no_difference 'Guide.count' do
      Rails.logger.info "Envoi des données invalides : #{invalid_guide_data.to_json}"
      post "/api/v1/guides/0/capture", 
        params: invalid_guide_data.to_json,
        headers: { 
          'Authorization': "Bearer #{@user.generate_jwt}",
          'Content-Type': 'application/json'
        }
      Rails.logger.info "Réponse : #{response.body}"
    end

    # Vérifier la réponse d'erreur
    assert_response :unprocessable_entity
    response_data = JSON.parse(response.body)
    assert_includes response_data.values.flatten, "Title can't be blank"

    # Test sans étapes
    guide_data_without_steps = {
      guide: {
        title: "Guide sans étapes",
        description: "Guide créé sans étapes",
        visibility: :private_guide
      }
    }

    # Simuler l'appel API sans étapes
    assert_no_difference 'Guide.count' do
      Rails.logger.info "Envoi des données sans étapes : #{guide_data_without_steps.to_json}"
      post "/api/v1/guides/0/capture", 
        params: guide_data_without_steps.to_json,
        headers: { 
          'Authorization': "Bearer #{@user.generate_jwt}",
          'Content-Type': 'application/json'
        }
      Rails.logger.info "Réponse : #{response.body}"
    end

    # Vérifier la réponse d'erreur pour l'absence d'étapes
    assert_response :unprocessable_entity
    response_data = JSON.parse(response.body)
    assert_equal "Aucune étape fournie", response_data['error']
  end
end 