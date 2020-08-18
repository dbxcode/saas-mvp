Rails.application.routes.draw do
  mount StripeEvent::Engine, at: '/webhooks/stripe'
  devise_for :accounts, controllers: { registrations: "registrations" }

  get "/plans" => "public#plans"
  post "plan/subscribe" => "subscriptions#choose_plan", as: :choose_plan

  get "subscription/success" => "subscriptions#stripe_success", as: :stripe_success
  get "subscription/cancel" => "subscriptions#stripe_cancel", as: :stripe_cancel

  root to: "public#home"
end
