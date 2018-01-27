# frozen_string_literal: true

require_relative 'form'

module Page
  class Home
    HOME_UI = {
      title: 'Tribal peoples need you<br>DONATE NOW'
    }.freeze

    def title
      HOME_UI[:title]
    end

    def form
      Form.new
    end
  end
end
