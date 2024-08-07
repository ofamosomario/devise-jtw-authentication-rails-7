# frozen_string_literal: true

# This module fixes issues with Rack sessions in environments where sessions are not enabled or necessary.
module RackSessionsFix
  extend ActiveSupport::Concern

  # A fake session class that mimics a Rack session but does not enable it.
  class FakeRackSession < Hash
    def enabled?
      false
    end

    def destroy; end
  end

  included do
    before_action :set_fake_session

    private

    # Sets a fake Rack session to avoid issues with session handling.
    def set_fake_session
      request.env['rack.session'] ||= FakeRackSession.new
    end
  end
end
