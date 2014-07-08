SimpleCDNServer::Application.routes.draw do

  root 'welcome#index'

  resources :accesses
end
