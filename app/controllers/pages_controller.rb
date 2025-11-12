require "net/http"
require "json"

class PagesController < ApplicationController
  include ActionView::Helpers::AssetUrlHelper
  include Rails.application.routes.url_helpers
  def home
    file_path = Rails.root.join("app", "assets", "dekdee.json")
    json_data_string = File.read(file_path)
    parsed_data = JSON.parse(json_data_string)
    @posts = parsed_data
  end
end
