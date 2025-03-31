require "active_record"
require "yaml"

begin
  puts "Vérification de la configuration de la base de données..."
  puts "ENV['DATABASE_URL']: #{ENV['DATABASE_URL'] ? '✅ Défini' : '❌ Non défini'}"
  
  # Charger la configuration depuis database.yml
  config_file = File.expand_path("../../config/database.yml", __FILE__)
  puts "Fichier de configuration : #{config_file}"
  
  unless File.exist?(config_file)
    puts "❌ Le fichier de configuration n'existe pas : #{config_file}"
    exit 1
  end
  
  config = YAML.load_file(config_file, aliases: true)
  env = ENV["RAILS_ENV"] || "development"
  
  puts "\nConfiguration résolue pour #{env}:"
  db_config = config[env]
  puts db_config.except('password').inspect
  
  if env == "production" && !ENV['DATABASE_URL']
    puts "\n⚠️  ATTENTION: DATABASE_URL n'est pas définie en production!"
    puts "Pour résoudre ce problème, définissez la variable d'environnement DATABASE_URL:"
    puts "export DATABASE_URL='postgres://username:password@host:5432/database_name'"
    exit 1
  end
  
  puts "\nTentative de connexion..."
  if env == "production" && ENV['DATABASE_URL']
    db_url = ENV['DATABASE_URL']
    puts "Utilisation de DATABASE_URL pour la connexion"
    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  else
    puts "Utilisation de la configuration du fichier database.yml"
    ActiveRecord::Base.establish_connection(db_config)
  end
  
  puts "✅ Connexion établie avec succès à la base de données."
  
  # Test simple de la connexion
  result = ActiveRecord::Base.connection.execute("SELECT 1 as test")
  puts "✅ Test de requête réussi : #{result.first}"
rescue => e
  puts "\n❌ Échec de la connexion : #{e.class} - #{e.message}"
  puts "\nBacktrace:"
  puts e.backtrace.take(5)
end 