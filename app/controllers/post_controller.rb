class PostController < ApplicationController
  def index
  end

  def show
    @id = params[:id]
    @post = DekdUtils.fetch_post(@id)
  end
end
