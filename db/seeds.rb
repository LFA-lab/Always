# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Nettoyage de la base de données
puts "Nettoyage de la base de données..."
ActiveRecord::Base.connection.disable_referential_integrity do
  [Answer, Question, Quiz, GuideFeedback, ParcoursGuide, Step, Guide, ServiceRequest, Parcours, User, Enterprise].each(&:delete_all)
end

# Création des entreprises
puts "Création des entreprises..."
enterprise1 = Enterprise.create!(
  name: "TechCorp",
  address: "123 Rue de la Tech, 75001 Paris"
)

enterprise2 = Enterprise.create!(
  name: "InnovSoft",
  address: "456 Avenue de l'Innovation, 75002 Paris"
)

# Création des utilisateurs
puts "Création des utilisateurs..."

# Admin
admin = User.create!(
  email: "admin@example.com",
  password: "password123",
  first_name: "Admin",
  last_name: "System",
  service: "Administration",
  enterprise: enterprise1,
  role: :admin
)

# Managers
manager1 = User.create!(
  email: "manager1@techcorp.com",
  password: "password123",
  first_name: "Jean",
  last_name: "Dupont",
  service: "Direction",
  enterprise: enterprise1,
  role: :manager
)

manager2 = User.create!(
  email: "manager2@innovsoft.com",
  password: "password123",
  first_name: "Marie",
  last_name: "Martin",
  service: "Direction",
  enterprise: enterprise2,
  role: :manager
)

# Users
user1 = User.create!(
  email: "user1@techcorp.com",
  password: "password123",
  first_name: "Pierre",
  last_name: "Durand",
  service: "Développement",
  enterprise: enterprise1,
  role: :user
)

user2 = User.create!(
  email: "user2@techcorp.com",
  password: "password123",
  first_name: "Sophie",
  last_name: "Petit",
  service: "Marketing",
  enterprise: enterprise1,
  role: :user
)

user3 = User.create!(
  email: "user3@innovsoft.com",
  password: "password123",
  first_name: "Lucas",
  last_name: "Moreau",
  service: "Design",
  enterprise: enterprise2,
  role: :user
)

# Création des guides
puts "Création des guides..."

# Guide 1 - TechCorp
guide1 = Guide.create!(
  title: "Guide d'utilisation de Git",
  description: "Apprenez à utiliser Git pour la gestion de versions",
  owner: manager1,
  enterprise: enterprise1,
  visibility: :public_guide
)

# Étapes pour le guide Git
Step.create!(
  guide: guide1,
  instruction_text: "Installation de Git",
  description: "1. Téléchargez Git depuis git-scm.com\n2. Installez Git sur votre machine\n3. Configurez votre identité Git",
  step_order: 1,
  visual_indicator: "click",
  element_selector: "#download-button",
  element_type: "button",
  timestamp: Time.current
)

Step.create!(
  guide: guide1,
  instruction_text: "Premiers commandes Git",
  description: "1. git init\n2. git add\n3. git commit\n4. git push",
  step_order: 2,
  visual_indicator: "click",
  element_selector: "#terminal",
  element_type: "div",
  timestamp: Time.current
)

# Quiz pour le guide Git
quiz1 = Quiz.create!(
  guide: guide1
)

question1 = Question.create!(
  quiz: quiz1,
  title: "Quelle commande permet d'initialiser un dépôt Git ?"
)

Answer.create!(
  question: question1,
  text: "git start",
  correct: false
)

Answer.create!(
  question: question1,
  text: "git init",
  correct: true
)

Answer.create!(
  question: question1,
  text: "git create",
  correct: false
)

Answer.create!(
  question: question1,
  text: "git new",
  correct: false
)

# Guide 2 - InnovSoft
guide2 = Guide.create!(
  title: "Guide de design UI/UX",
  description: "Les bonnes pratiques de design d'interface",
  owner: manager2,
  enterprise: enterprise2,
  visibility: :public_guide
)

# Étapes pour le guide UI/UX
Step.create!(
  guide: guide2,
  instruction_text: "Principes de base",
  description: "1. Cohérence visuelle\n2. Hiérarchie visuelle\n3. Feedback utilisateur",
  step_order: 1,
  screenshot_url: "https://example.com/ui-principles.png",
  visual_indicator: "click",
  element_selector: "#principles",
  element_type: "div",
  timestamp: Time.current
)

Step.create!(
  guide: guide2,
  instruction_text: "Outils de design",
  description: "1. Figma\n2. Adobe XD\n3. Sketch",
  step_order: 2,
  screenshot_url: "https://example.com/design-tools.png",
  visual_indicator: "click",
  element_selector: "#tools",
  element_type: "div",
  timestamp: Time.current
)

# Quiz pour le guide UI/UX
quiz2 = Quiz.create!(
  guide: guide2
)

question2 = Question.create!(
  quiz: quiz2,
  title: "Quel est le principe fondamental du design UI/UX ?"
)

Answer.create!(
  question: question2,
  text: "La beauté",
  correct: false
)

Answer.create!(
  question: question2,
  text: "L'expérience utilisateur",
  correct: true
)

Answer.create!(
  question: question2,
  text: "La complexité",
  correct: false
)

Answer.create!(
  question: question2,
  text: "La rapidité",
  correct: false
)

# Création des parcours
puts "Création des parcours..."

parcours1 = Parcours.create!(
  title: "Formation Développeur",
  description: "Parcours complet pour devenir développeur",
  enterprise: enterprise1,
  owner: manager1
)

ParcoursGuide.create!(
  parcours: parcours1,
  guide: guide1,
  order_in_parcours: 1
)

parcours2 = Parcours.create!(
  title: "Formation Design",
  description: "Parcours complet pour devenir designer",
  enterprise: enterprise2,
  owner: manager2
)

ParcoursGuide.create!(
  parcours: parcours2,
  guide: guide2,
  order_in_parcours: 1
)

# Création des feedbacks
puts "Création des feedbacks..."

GuideFeedback.create!(
  guide: guide1,
  user: user1,
  stars: 5,
  comment: "Très bien expliqué, merci !",
  time_saved: 2
)

GuideFeedback.create!(
  guide: guide2,
  user: user3,
  stars: 4,
  comment: "Utile pour mon travail quotidien",
  time_saved: 1
)

# Création des demandes de service
puts "Création des demandes de service..."

ServiceRequest.create!(
  description: "Je rencontre des problèmes avec les branches Git",
  status: "pending",
  user: user1
)

ServiceRequest.create!(
  description: "Je voudrais des conseils sur l'accessibilité",
  status: "pending",
  user: user3
)

puts "Seed terminé avec succès !"
puts "Vous pouvez vous connecter avec :"
puts "Admin : admin@example.com / password123"
puts "Manager 1 : manager1@techcorp.com / password123"
puts "Manager 2 : manager2@innovsoft.com / password123"
puts "User 1 : user1@techcorp.com / password123"
puts "User 2 : user2@techcorp.com / password123"
puts "User 3 : user3@innovsoft.com / password123"
