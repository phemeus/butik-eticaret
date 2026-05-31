# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: "_butik_eticaret_session"

Rails.application.config.middleware.use ActionDispatch::Cookies
Rails.application.config.middleware.use ActionDispatch::Session::CookieStore, Rails.application.config.session_options
