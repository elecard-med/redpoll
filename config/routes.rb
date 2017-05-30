# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
# get 'anketa', :to => 'anketa#index'
resources :redpoll_polls
get '/redpoll_questions/:redpoll_poll_id', to: 'redpoll_questions#index', as: 'redpoll_questions'
post '/redpoll_questions/:redpoll_poll_id', to: 'redpoll_questions#create'
get '/redpoll_questions/new/:redpoll_poll_id', to: 'redpoll_questions#new', as: 'new_redpoll_question'
get '/redpoll_questions/:id/edit', to: 'redpoll_questions#edit', as: 'edit_redpoll_question'

get '/redpoll_questions/down_position/:redpoll_question_id', to: 'redpoll_questions#down_position', as: 'down_position_redpoll_question'
get '/redpoll_questions/up_position/:redpoll_question_id', to: 'redpoll_questions#up_position', as: 'up_position_redpoll_question'

patch '/redpoll_questions/:id', to: 'redpoll_questions#update', as: 'redpoll_question'
delete '/redpoll_questions/:id', to: 'redpoll_questions#destroy'

get '/redpoll_variants/:redpoll_question_id', to: 'redpoll_variants#index', as: 'redpoll_variants'
post '/redpoll_variants/:redpoll_question_id', to: 'redpoll_variants#create'
get '/redpoll_variants/new/:redpoll_question_id', to: 'redpoll_variants#new', as: 'new_redpoll_variant'
get '/redpoll_variants/:id/edit', to: 'redpoll_variants#edit', as: 'edit_redpoll_variant'

get '/redpoll_variants/down_position/:redpoll_variant_id', to: 'redpoll_variants#down_position', as: 'down_position_redpoll_variant'
get '/redpoll_variants/up_position/:redpoll_variant_id', to: 'redpoll_variants#up_position', as: 'up_position_redpoll_variant'

patch '/redpoll_variants/:id', to: 'redpoll_variants#update', as: 'redpoll_variant'
delete '/redpoll_variants/:id', to: 'redpoll_variants#destroy'

get '/redpoll_votes/:redpoll_poll_id', to: 'redpoll_votes#index', as: 'redpoll_votes'
get '/redpoll_votes/resetpoll/:redpoll_poll_id', to: 'redpoll_votes#resetpoll', as: 'redpoll_votes_reset'
get '/redpoll_votes/result/:redpoll_poll_id', to: 'redpoll_votes#result', as: 'redpoll_votes_result'
get '/redpoll_votes/adminresult/:redpoll_poll_id', to: 'redpoll_votes#adminresult', as: 'redpoll_votes_adminresult'
post '/redpoll_votes/:redpoll_poll_id', to: 'redpoll_votes#vote'
