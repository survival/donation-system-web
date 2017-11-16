# frozen_string_literal: true

require_relative 'form'

module Page
  class Home
    HOME_UI = {
      title: 'Make a donation'
    }.freeze

    def title
      HOME_UI[:title]
    end

    def form
      Form.new
    end
  end
end
