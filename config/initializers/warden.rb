Rails.application.config.middleware.insert_after ActionDispatch::Session::CookieStore, Warden::Manager do |manager|
  manager.default_strategies(scope: :user).unshift :public_page
  manager.failure_app = Devise::FailureApp.new
end

Warden::Manager.after_set_user do |user, auth, opts|
  auth.cookies.signed['user.id'] = user.id
  auth.cookies.signed['user.expires_at'] = 30.minutes.from_now
end

Warden::Manager.before_logout do |user, auth, opts|
  auth.cookies.signed['user.id'] = nil
  auth.cookies.signed['user.expires_at'] = nil
end 