#!/bin/bash

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
print_message() {
    echo -e "${2}${1}${NC}"
}

# Vérification de la version de Ruby
REQUIRED_RUBY_VERSION=$(cat .ruby-version | tr -d '\n')
CURRENT_RUBY_VERSION=$(ruby -v | cut -d' ' -f2)
if [ "$CURRENT_RUBY_VERSION" != "$REQUIRED_RUBY_VERSION" ]; then
    print_message "❌ Erreur : Version de Ruby incorrecte. Requise: $REQUIRED_RUBY_VERSION, Installée: $CURRENT_RUBY_VERSION" "$RED"
    exit 1
fi

print_message "✅ Vérification de la version Ruby : OK" "$GREEN"

# Vérification de la branche courante
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    print_message "❌ Erreur : Vous devez être sur la branche main" "$RED"
    exit 1
fi

print_message "✅ Vérification de la branche : OK" "$GREEN"

# Suppression des anciens assets
print_message "🗑️  Suppression des anciens assets..." "$YELLOW"
rm -rf public/assets/*
print_message "✅ Nettoyage des assets terminé" "$GREEN"

# Précompilation des assets
print_message "🔄 Précompilation des assets en production..." "$YELLOW"
RAILS_ENV=production bundle exec rake assets:precompile

# Vérification de la présence des fichiers générés
if [ ! -d "public/assets" ] || [ -z "$(ls -A public/assets)" ]; then
    print_message "❌ Erreur : Aucun asset n'a été généré" "$RED"
    exit 1
fi

print_message "✅ Vérification des assets générés : OK" "$GREEN"

# Commit des nouveaux assets
print_message "💾 Commit des nouveaux assets..." "$YELLOW"
git add -f public/assets/
git commit -m "chore: mise à jour des assets précompilés pour Heroku"

# Push sur Heroku
print_message "🚀 Push sur Heroku..." "$YELLOW"
git push heroku main

# Configuration optionnelle de RAILS_SKIP_ASSET_COMPILATION
print_message "⚙️  Configuration de RAILS_SKIP_ASSET_COMPILATION..." "$YELLOW"
heroku config:set RAILS_SKIP_ASSET_COMPILATION=true

print_message "✨ Toutes les étapes ont été exécutées avec succès !" "$GREEN" 