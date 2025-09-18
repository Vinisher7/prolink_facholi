class Api::V1::LinesController < Api::V1::ApplicationController
  before_action :authorize_user!

  def index
    render json: { 'data': Line.all }
  end
end
