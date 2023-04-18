# -*- encoding : utf-8 -*-
Rails.application.routes.draw do
  match '/oauth/token' , via: [:get, :post],         :to => 'application#mocks',         :as => :token
  match '/oauth/access_token' , via: [:get, :post],  :to => 'application#mocks',  :as => :access_token
  match '/oauth/request_token' , via: [:get, :post], :to => 'application#mocks', :as => :request_token
  match '/oauth/authorize', via: [:get, :post],     :to => 'application#mocks',     :as => :authorize
  match '/oauth', via: [:get, :post],               :to => 'application#mocks',         :as => :oauth
  match '/oauth/revoke', via: [:get, :post],        :to => 'application#mocks',        :as => :oauth_revoke
  match '/oauth/invalidate', via: [:get, :post],    :to => 'application#mocks',    :as => :oauth_invalidate
  match '/oauth/capabilities', via: [:get, :post],  :to => 'application#mocks',  :as => :oauth_capabilities

  match '/analytics/dashboard', via: [:get, :post], :to => 'application#mocks'
  match '/analytics/signup_by_date', via: [:get, :post], :to => 'application#mocks'
  match '/analytics/environment_by_date', via: [:get, :post], :to => 'application#mocks'
  match '/analytics/course_by_date', via: [:get, :post], :to => 'application#mocks'
  match '/analytics/post_by_date', via: [:get, :post], :to => 'application#mocks'

  match '/search', via: [:get, :post], :to => 'application#mocks', :as => :search
  # Rota para todos os ambientes em geral e quando houver mais de um filtro selecionado
  match '/search/environments' , via: [:get, :post], :to => 'application#mocks', :as => :search_environments
  match '/search/profiles', via: [:get, :post], :to => 'application#mocks', :as => :search_profiles

  post "presence/auth"
  post "presence/multiauth"
  post "presence/send_chat_message"
  get "presence/last_messages_with"
  get "vis/dashboard/teacher_participation_interaction"

  match '/jobs/notify', via: [:get, :post], :to => 'application#mocks', :as => :notify
  resources :statuses, :only => [:show, :create, :destroy] do
    member do
      post :respond
    end
  end

  # sessions routes
  match '/signup', via: [:get, :post], :to => 'application#mocks', :as => :signup
  get '/login' => 'application#mocks', :as => :login
  match '/logout', via: [:get, :post], :to => 'application#mocks', :as => :logout

  # Authentications
  resources :authentications, :only => [:create]
  get '/auth/:provider/callback' => 'application#mocks', :as => :omniauth_auth
  get '/auth/failure' => 'application#mocks', :as => :omniauth_fallback
  get 'auth/facebook', :as => :facebook_authentication

  get '/recover_username_password' => 'application#mocks',
    :as => :recover_username_password
  post '/recover_password' => 'application#mocks', :as => :recover_password

  match '/resend_activation', via: [:get, :post], :to => 'application#mocks',
    :as => :resend_activation
  match '/account/edit', via: [:get, :post], :to => 'application#mocks', :as => :edit_account_from_email
  resources :sessions, :only => [:new, :create, :destroy]

  # site routes
  match '/about', via: [:get, :post], :to => 'application#mocks', :as => :about
  match 'contact', via: [:get, :post], :to => 'application#mocks', :as => :contact

  # Space
  resources :spaces, :except => [:index] do
    member do
      get :admin_members
      get :mural
      get :students_endless
      get :admin_subjects
      get :subject_participation_report
      get :lecture_participation_report
      get :students_participation_report
      get :students_participation_report_show
    end

    resources :folders, :only => [:update, :create, :index] do
      member do
        get :download
        delete :destroy_folder
        delete :destroy_file
        post :do_the_upload
      end
    end

    resources :subjects, :except => [:index] do
      resources :lectures do
        member do
          post :rate
          post :done
          get :page_content
        end
      end
    end

    resources :users, :only => [:index]
    resources :canvas, :only => [:show]
  end

  resources :exercises, :only => :show do
    resources :results, :only => [:index, :create, :update, :edit]
    resources :questions, :only => :show do
      resources :choices, :only => [:create, :update]
    end
  end

  #Invitations
  resources :invitations, :only => [:show, :destroy] do
    member do
      post :resend_email
    end
    collection do
      post :destroy_invitations
    end
  end

  # Users
  resources :users, :except => [:index] do
    member do
      get :edit_account
      put :update_account
      get :forgot_password
      post :forgot_password
      get :signup_completed
      get :invite
      put :deactivate
      get :home
      get :my_wall
      get :account
      get :contacts_endless
      get :environments_endless
      get :show_mural
      get :curriculum
    end

    collection do
      get :auto_complete
    end

    resources :social_networks, :only => [:destroy]

    resources :friendships, :only => [:index, :create, :destroy, :new] do
      member do
        post :resend_email
      end
    end

    resources :messages, :except => [:destroy, :edit, :update] do
      collection do
        get :index_sent
        post :delete_selected
      end
    end

    resources :plans, :only => [:index]
    resources :experiences
    resources :educations, :except => [:new, :edit]
    resources :environments, :only => [:index]
    resource :explore_tour, :only => :create
    resources :oauth_clients
  end

  resources :oauth_clients, :only => :new

  match 'users/activate/:id', via: [:get, :post], :to => 'application#mocks', :as => :activate

  # Indexes
  match '/teach', via: [:get, :post], :to => 'application#mocks', :as => :teach_index
  get '/environments', via: [:get, :post], :to => 'application#mocks', :as => :environments_index

  resources :plans, :only => [] do
    member do
      get :confirm
      post :confirm
      get :options
    end

    resources :invoices, :only => [:index, :show] do
      member do
        post :pay
      end
    end
  end

  match '/payment/callback', via: [:get, :post], :to => 'application#mocks',
    :as => :payment_callback
  match '/payment/success', via: [:get, :post], :to => 'application#mocks', :as => :payment_success

  resources :partners, :only => [:show, :index] do
    member do
      post :contact
      get :success
    end

    resources :partner_environment_associations, :as => :clients,
      :only => [:create, :index, :new] do
        resources :plans, :only => [:show] do
          member do
            get :options
          end
          resources :invoices, :only => [:index]
        end
    end
    resources :partner_user_associations, :as => :collaborators, :only => :index
    resources :invoices, :only => [:index]
  end

  resources :environments, :path => 'application#mocks', :except => [:index] do
    member do
      get :preview
      get :admin_courses
      get :admin_members
      post :destroy_members
      post :search_users_admin
    end
    resources :courses do
      member do
        get :preview
        get :admin_spaces
        get :admin_members_requests
        get :admin_invitations
        get :admin_manage_invitations
        get :teacher_participation_report
        post :invite_members
        post :accept
        post :join
        post :unjoin
        get :publish
        get :unpublish
        get :admin_members
        post :destroy_members
        post :destroy_invitations
        post :search_users_admin
        post :moderate_members_requests
        post :accept
        post :deny
      end

      resources :users, :only => [:index]
      resources :users, :only => :show do
        match :roles, :to => 'application#mocks', :via => :post, :as => :roles
      end
      resources :user_course_invitations, :only => [:show]
      resources :plans, :only => [:create]
    end

    resources :users, :only => [:index]
    resources :users, :only => :show do
      resources :roles, :only => :index
      match :roles, :to => 'application#mocks', :via => :post, :as => :roles_2
    end
    resources :plans, :only => [:create]
  end

  resources :pages, :only => :show

  root :to => 'application#mocks', :as => :home
  root :to => 'application#mocks', :as => :application

  namespace 'api', :defaults => { :format => :json } do
    resources :environments, :except => [:new, :edit] do
      resources :courses, :except => [:new, :edit], :shallow => true
      resources :users, :only => :index
    end

    resources :courses, :except => [:new, :edit, :index, :create] do
      resources :spaces, :except => [:new, :edit], :shallow => true
      resources :users, :only => :index
      resources :course_enrollments, :only => [:create, :index],
        :path => 'enrollments', :as => 'enrollments'
    end

    resources :course_enrollments, :only => [:show, :destroy],
        :path => 'enrollments', :as => 'enrollments'

    resources :spaces, :except => [:new, :edit, :index, :create] do
      resources :subjects, :only => [:create, :index]
      resources :users, :only => :index
      resources :statuses, :only => [:index, :create] do
        get 'timeline', :on => :collection
      end
      resources :folders, :only => :index
      resources :canvas, :only => [:create, :index]
    end

    resources :subjects, :except => [:new, :edit, :index, :create] do
      resources :lectures, :only => [:create, :index]
      resources :asset_reports, :path => "progress", :only => [:index]
    end

    resources :lectures, :except => [:new, :edit, :index, :create] do
      resources :user, :only => :index
      resources :statuses, :only => [:index, :create]
      resources :asset_reports, :path => "progress", :only => [:index]
    end

    resources :users, :only => :show do
      resources :course_enrollments, :only => :index, :path => :enrollments,
        :as => 'enrollments'
      resources :spaces, :only => :index
      resources :statuses, :only => [:index, :create] do
        get 'timeline', :on => :collection
      end
      resources :users, :only => :index, :path => :contacts,
        :as => :contacts
      resources :chats, :only => :index
      resources :friendships, :path => :connections,
        :as => 'connections', :only => [:index, :create]
      resources :asset_reports, :path => "progress", :only => [:index]
    end

    match 'me', via: [:get, :post], :to => 'application#mocks'

    resources :statuses, :only => [:show, :destroy] do
      resources :answers, :only => [:index, :create]
    end

    resources :chats, :only => :show do
      resources :chat_messages, :only => :index, :as => :messages
    end

    resources :chat_messages, :only => :show

    resources :folders, :only => [:show, :index] do
      resources :myfiles, :path => "files", :only => [:index, :create]
      resources :folders, :only => [:index, :create]
    end

    resources :folders, :only => [:update, :destroy]

    resources :myfiles, :path => "files", :only => [:show, :destroy]
    resources :canvas, :only => [:show, :update, :destroy]
    resources :asset_reports, :path => "progress", :only => [:show, :update]

    resources :friendships, :path => "connections",
      :only => [:show, :update, :destroy]

    match "vis/spaces/:space_id/lecture_participation" , via: [:get, :post],
      :to => 'application#mocks',
      :as => :vis_lecture_participation
    match "vis/spaces/:space_id/subject_activities" , via: [:get, :post],
      :to => 'application#mocks',
      :as => :vis_subject_activities
    match "vis/spaces/:space_id/students_participation" , via: [:get, :post],
      :to => 'application#mocks',
      :as => :vis_students_participation

    # Captura exceções ActionController::RoutingError
    match '/404' , via: [:get, :post], :to => 'application#mocks'
  end
end