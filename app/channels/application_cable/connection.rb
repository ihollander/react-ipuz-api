module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_current_user
    end

    private 
    
    def decoded_token
      token = request.params[:'access-token']
      begin
        JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end

    def find_current_user
      if decoded_token
        user_id = decoded_token[0]['user_id']
        @current_user = User.find_by(id: user_id)
        @current_user
      else
        reject_unauthorized_connection
      end
    end

  end
end
