require "net/http"
require "json"

class PagesController < ApplicationController
  def home
    # TODO: duplicate to ./post_controller.rb#index
    @posts = Rails
      .public_path.join("dekd", "index.json")
      .then { |it| File.read it }
      .then { |it| JSON.parse it }
  end
end
