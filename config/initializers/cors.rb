Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000',
            'http://127.0.0.1:3000',
            'chrome-extension://*',
            'https://kitt.lewagon.com'
    
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      expose: ['X-CSRF-Token'],
      max_age: 600,
      allow_headers: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept'],
      supports_credentials: true,
      expose_headers: ['Content-Type', 'X-CSRF-Token']
  end
end 