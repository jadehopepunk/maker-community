module Admin
  class AdminController < ApplicationController
    before_action :set_section
    layout 'admin'
    SECTIONS = {
      'people' => 'people',
      'events' => 'program'
    }

    def index; end

    private

    def set_section
      controller_name = params[:controller].split('/')[1]
      @section = SECTIONS[controller_name]
    end
  end
end
