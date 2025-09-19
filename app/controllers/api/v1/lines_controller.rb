class Api::V1::LinesController < Api::V1::ApplicationController
  before_action :authorize_user!

  def index
  response = PaginationFormatter::PaginationFormatterService.call(
      page: params[:page],
      entity: Line.order(created_at: :desc)
    )

    return render json: { error: response.table[:message] }, status: :bad_request unless response.success?

    render json: { pagination: response.response[:pagination], data: response.response[:entity_data] }
  end
end
