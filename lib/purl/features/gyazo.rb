require 'open-uri'
require 'fileutils'

module Purl
  module Features::Gyazo
    class << self
      def operators
        [Op.new(:gyazo, 1)]
      end

      attr_reader :cache_path
      def options=(options)
        options = {
          :cache_path => File.join(RAILS_ROOT, 'public', 'purl'),
        }.merge(options)

        @cache_path = options[:cache_path]
      end

      def gyazo(id)
        id.gsub!(/[^a-f0-9]/, '')

        path = File.join(@cache_path, "(#{id}):gyazo:to.png")

        unless File.exist?(path)
          FileUtils.makedirs(@cache_path)
          data = open("http://gyazo.com/#{id}.png").read
          open(path, "wb+"){|file| file.write(data)}
        else
          data = open(path).read
        end

        Result.new(Magick::ImageList.new.from_blob(data))
      end
    end
  end
end
