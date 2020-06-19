class SubtypeOptionsController < ApplicationController

  def create
    subtype_option_params[:options].map do |option|
      SubtypeOption.new(name: option, subtype_id: params[:subtype_id]).save
    end
    render json: { message: 'Subtype option(s) successfully created' }, status: :created
  end

  private

  def subtype_option_params
    params.permit(options: [])
  end
end
