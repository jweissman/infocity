module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_pawn

    def connect
      self.current_pawn = find_matching_pawn
    end

    private
      def find_matching_pawn
        # binding.pry
        key_value = request.params[:pawn_key] #cookies.signed[:pawn_key]
        logger.info "FOUND KEY '#{key_value}'"
        if verified_pawn = Pawn.for_key(value: key_value) #find_by(id: cookies.signed[:user_id])
          logger.info "FOUND MATCHING PAWN: #{verified_pawn.inspect}"
          verified_pawn
        else
          logger.info "REJECT UNAUTHORIZED REQUEST"
          reject_unauthorized_connection
        end
      end
  end
end
