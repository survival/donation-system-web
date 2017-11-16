# frozen_string_literal: true

module Page
  class Success
    SUCCESS_UI = {
      title: 'Thanks for your donation',
      image_url: 'pictures/10712/baiga-briefing_original.jpg',
      image_width: '808',
      image_height: '483',
      image_description: 'Baiga briefing original picture',
      body: %(Lorem ipsum dolor sit amet consectetur adipiscing
        elit nibh' 'dignissim suspendisse, imperdiet scelerisque
        odio consequat proin hendrerit fusce leo' 'at eros, maecenas
        arcu risus integer egestas sed facilisis tellus vivamus.),
      share_this_title: 'Tell the world about your contribution'
    }.freeze

    def initialize(images_baseurl)
      @images_baseurl = images_baseurl
    end

    def title
      ui(:title)
    end

    def image_url
      "#{images_baseurl}/#{ui(:image_url)}"
    end

    def ui(code)
      SUCCESS_UI[code]
    end

    private

    attr_reader :images_baseurl
  end
end
