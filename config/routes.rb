ActionController::Routing::Routes.draw do |map|
  map.resources(:invoice,
                :collection => {
                  :autocreate => :get,
                  :autofill => :get
                },
                :member => {
                  :outstanding => :get
                },
                :shallow => true) do |invoice|
    invoice.resources :payments, :only => [:new, :create]
  end

  map.resources :payments, :only => [:new, :create]
end
