class ApplicationController < ActionController::Base
	http_basic_authenticate_with name: 'sammy', password: 'shark', except: [:index, :show]
end
