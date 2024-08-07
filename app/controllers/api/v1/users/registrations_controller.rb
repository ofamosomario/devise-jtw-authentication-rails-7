# frozen_string_literal: true

module Api
  module V1
    module Users
      # Registration Class Devise
      class RegistrationsController < Devise::RegistrationsController
        include RackSessionsFix

        respond_to :json

        private

        def respond_with(resource, _opts = {})
          case request.method
          when 'POST'
            handle_post_response(resource)
          when 'DELETE'
            handle_delete_response
          else
            handle_error_response(resource)
          end
        end

        def handle_post_response(resource)
          if resource.persisted?
            render json: {
              status: { code: :ok, message: 'Signed up successfully.' },
              data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
            }, status: :ok
          else
            handle_error_response(resource)
          end
        end

        def handle_delete_response
          render json: {
            status: { code: :ok, message: 'Account deleted successfully.' }
          }, status: :ok
        end

        def handle_error_response(resource)
          render json: {
            status: {
              code: :unprocessable_entity,
              message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
            }
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
