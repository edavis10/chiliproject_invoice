ActionController::Routing::Routes.draw do |map|
  map.resources(:invoice,
                :collection => {
                  :autocreate => :get,
                  :autofill => :get
                },
                :member => {
                  :outstanding => :get
                })
end
