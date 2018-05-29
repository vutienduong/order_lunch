module OrderLunch
  class V1::Users < Base
    before { hello_world }

    resource :users do
      get :list_users do
        User.limit(10)
      end

      desc 'Get user info'
      params do
        requires :user_id, type: Integer
      end
      get ':user_id' do
        user = User.find(params[:user_id])
        UserSerializer.new(user)
        #render json: user
      end
    end

    helpers do
      def hello_world
      end
    end
  end
end
