# DEVBOOK "ALWAYS" – Version Finale MVP (Sans Application Windows)

## 1. Introduction & Vision
- **Always** est un SaaS B2B qui permet de capturer un processus via une extension Chrome.
- Génère un guide interactif avec quiz et feedback obligatoire.
- Les guides peuvent être publiés en mode privé (usage interne) ou public (SEO-friendly).
- Un service de prestation est disponible pour aider les managers dans la création de guides.
- Le projet est déployé sur Heroku sous le nom "always-mvp".

## 2. Architecture Globale & Hexagonale
- **Clients de Capture** : Extension Chrome (capture des clics, saisies, visionnage en mode overlay pour les users B2B).
- **Backend Rails** : Construit en Rails 7, architecture hexagonale (Domain, Ports, Adapters) gère guides, quiz, feedback, parcours, et service_requests.
- **Stockage** : PostgreSQL (Heroku Postgres) et Active Storage (Amazon S3).
- **Interface Web** : Dashboard, Landing Page, pages de guides, parcours.

## 3. Stack Technique
- Rails 7 (Ruby 3.2.3)
- PostgreSQL (via Heroku)
- Active Storage avec Amazon S3
- Devise pour l'authentification (rôles : admin, manager, user)
- FriendlyId pour les slugs SEO des guides publics
- Meta-tags pour les métadonnées SEO
- Quiz, Question, Answer, GuideFeedback pour le QCM et les retours
- Extension Chrome (Manifest V3) pour la capture
- ServiceRequest pour les demandes de prestation

## 4. Installation & Configuration (en local)
- Cloner le dépôt, installer les dépendances avec `bundle install` et `yarn install`
- Configurer la base avec `bundle exec rails db:create`, `db:migrate`, et `db:seed`
- Démarrer le serveur avec `bundle exec rails s`

## 5. Arborescence du Projet
- Structure Rails classique avec dossiers `app/` (controllers, models, views, helpers, jobs, services), `config/`, `db/`, etc.
- Un fichier **Procfile** à la racine pour Heroku (`web: bundle exec rails s -p $PORT`).
- Dossier pour l'extension Chrome (manifest.json, background.js, content_script.js, popup.html, popup.js).

## 6. Modèles & Relations
- **Enterprise** : a_many :users, services
- **User** : appartient à une Enterprise (optionnel), avec enum role { admin, manager, user }
- **Guide** : appartient à un owner (User), peut être privé (0) ou public (1), utilise FriendlyId pour le slug
- **Step** : appartient à un guide, contient ordre, texte, capture
- **Quiz, Question, Answer** : pour le QCM
- **GuideFeedback** : rating, commentaire, lié à un guide (et user optionnel)
- **Parcours** : regroupement de guides via parcours_guides
- **ServiceRequest** : demande de prestation de services par le manager

## 7. Flux Utilisateurs (B2B)
- **Manager** : S'inscrit, accède au Dashboard, utilise l'extension pour capturer et éditer un guide, choisit la visibilité (privé/public), assigne le guide aux users internes, et consulte les statistiques.
- **User** (Employé) : Reçoit un mail de bienvenue, accède au Dashboard, visionne le guide (via page ou extension), complète le quiz et laisse un feedback.
- **Guide Public** : Accessible via un lien SEO-friendly, consultable par n'importe qui, avec quiz (optionnel) et feedback.

## 8. Fonctionnalités Clés
- **Guide Interactif** : Capture via l'extension, édition type ScribeHow (réorganisation, modification des captures, ajout de descriptions).
- **Quiz et Feedback Obligatoire** : Pour vérifier la compréhension et assurer une preuve sociale.
- **Prestation de Services** : Option "Demander une prestation" sur le Dashboard Manager.

## 9. Applications Clients de Capture
- **Extension Chrome** : Pour la capture et visionnage des guides (fonctionne en mode overlay pour les users B2B).
- **(Pas d'application Windows dans ce MVP)**

## 10. SEO Automatique pour Guides Publics
- Utilisation de FriendlyId pour générer un slug à partir du titre.
- Mise en place des meta-tags pour définir title et meta description.
- Un job (via Sidekiq ou similaire) met à jour le sitemap et ping Google lors de la publication d'un guide public.

## 11. Déploiement sur Heroku & Roadmap
- Déploiement via Heroku avec l'application nommée "always-mvp"
- Utilisation de l'add-on Heroku Postgres et configuration d'Active Storage avec Amazon S3.
- Roadmap : notifications, rapports, optimisation SEO, développement d'une application mobile éventuelle.

## 12. Une Seule Interface : Affichage Conditionnel
- Les contrôleurs et vues filtrent les fonctionnalités selon le rôle de l'utilisateur (Manager voit "Créer un guide", "Demander une prestation", etc. ; User voit ses guides assignés).

## 13. Landing Page (Temps total + Feedbacks)
- Affiche un compteur d'heures économisées et des feedbacks en rangées de 3.
- CTA pour "Créer un guide" ou "Se connecter".

## 14. Conclusion
**Always** est une solution SaaS B2B complète permettant aux managers de capturer, éditer et publier des guides interactifs, avec la possibilité de les rendre publics pour une stratégie SEO. Le projet utilise une architecture hexagonale, une extension Chrome pour la capture, et offre un système de quiz et feedback obligatoire, ainsi qu'une option de demande de prestation. L'application est déployée sur Heroku sous le nom "always-mvp".

---

## Rules Génériques pour Cursor.ai

Pour chaque demande future concernant le projet Always via Cursor.ai, je suivrai les règles génériques suivantes pour maintenir le projet de manière lean :

1. **Respecter l'architecture définie** : Conserver l'architecture hexagonale et la séparation claire entre Domain, Ports et Adapters.
2. **Utiliser une interface unifiée** : Toutes les modifications ou ajouts doivent être intégrés dans la même base de code Rails, avec des vues conditionnelles selon le rôle (Manager, User).
3. **Garder le projet lean** : Ajouter uniquement des fonctionnalités essentielles au MVP, en gardant le code simple et modulable.
4. **Documenter les modifications** : Chaque nouvelle demande doit être accompagnée d'une mise à jour du DevBook et de commentaires clairs dans le code.
5. **Maintenir les conventions** : Respecter l'arborescence des dossiers et l'usage des gems recommandées pour assurer une cohérence globale du projet.
6. **Suivre les instructions de déploiement** : S'assurer que le déploiement sur Heroku fonctionne toujours correctement, notamment avec la configuration de PostgreSQL et Active Storage.
7. **Analyser le code existant** : Vérifier si des éléments sont déjà partiellement en place pour éviter les doublons. 