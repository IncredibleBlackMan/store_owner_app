class SubtypesController < ApplicationController
  before_action :find_subtype

  def update
    if @subtype['user_id'] == @current_user.id
      @subtype&.update(subtype_params)
      render json: { message: 'Subtype successfully updated' }, status: :ok
    else
      render json: {
        message: 'You have to be the owner to update this subtype'
      }, status: :forbidden
    end
  end

  private

  def find_subtype
    @subtype = Subtype.find(params[:subtype_id])
  rescue StandardError => e
    render json: {
      errors: e.message
    }, status: :bad_request
  end

  def subtype_params
    params.required(:subtype).permit(:name)
  end
end
