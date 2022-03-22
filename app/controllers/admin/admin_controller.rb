module Admin
  class AdminController < ApplicationController
    before_action :set_section
    before_action -> { authorize :application, :can_admin? }

    layout 'admin'

    def index; end

    private

    def set_section
      @section = path_section
    end

    def path_section
      request.path.split('/').reject(&:blank?)[1]
    end
  end
end
