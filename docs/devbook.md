# Documentation du Développeur

## Routes d'Authentification

### Routes Devise
```ruby
devise_for :users, controllers: {
  sessions: 'users/sessions',
  registrations: 'users/registrations',
  passwords: 'users/passwords'
}
```

- `GET /users/sign_in` - Page de connexion
- `POST /users/sign_in` - Traitement de la connexion
- `DELETE /users/sign_out` - Déconnexion
- `GET /users/sign_up` - Page d'inscription
- `POST /users` - Création d'un compte
- `GET /users/password/new` - Demande de réinitialisation de mot de passe
- `GET /users/password/edit` - Page de réinitialisation de mot de passe
- `PUT /users/password` - Mise à jour du mot de passe

### Redirection après Connexion
- Pour les managers : `dashboard_enterprise_path(resource.enterprise)`
- Pour les autres utilisateurs : `root_path`

## Dashboard Manager

### Routes
```ruby
resources :enterprises, only: [:show, :edit, :update] do
  member do
    get 'dashboard'
    get 'analytics'
  end
end
```

- `GET /enterprises/:id/dashboard` - Dashboard principal du manager
- `GET /enterprises/:id/analytics` - Page d'analytiques
- `GET /enterprises/:id` - Détails de l'entreprise
- `GET /enterprises/:id/edit` - Édition de l'entreprise
- `PATCH/PUT /enterprises/:id` - Mise à jour de l'entreprise

### Contrôleur
Le `EnterprisesController` gère l'accès au dashboard avec :
- Authentification requise
- Vérification du rôle manager
- Récupération des données de l'entreprise

### Vue Dashboard
La vue `dashboard.html.erb` affiche :

1. **Statistiques**
   - Total des utilisateurs
   - Total des guides
   - Total des parcours

2. **Activité Récente**
   - Liste des 5 derniers guides
   - Liste des 5 derniers utilisateurs

3. **Actions Rapides**
   - Créer un guide
   - Ouvrir l'extension Chrome
   - Créer un parcours

### Sécurité
- Vérification du rôle manager
- Vérification de l'appartenance à l'entreprise
- Redirection vers la page d'accueil en cas d'accès non autorisé

## Extension Chrome

### Intégration
- Lien direct vers l'extension depuis le dashboard
- URL : `chrome-extension://hyperion-guide-capture/popup.html`

### Fonctionnalités
- Capture d'écran
- Enregistrement des interactions
- Création de guides
- Synchronisation avec le backend

### API
```ruby
namespace :api do
  namespace :v1 do
    resources :guides, only: [:index, :show, :create, :update] do
      resources :steps, only: [:create, :update, :destroy]
      resources :quizzes, only: [:create, :update, :destroy]
      resources :guide_feedbacks, only: [:create]
    end
  end
end
``` 