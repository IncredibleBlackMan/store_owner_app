class SubtypeOptionPricingController < ApplicationController
  def create
    pricing = SubtypeOptionPricing.new(pricing_params.merge(product_id: params[:product_id]))
    if pricing.save
      render json: {
        message: 'Pricing created successfully'
      }, status: :created
    else
      render json: {
        errors: pricing.errors.full_messages
      }, status: :bad_request
    end
  end

  private

  def pricing_params
    params.require(:subtype_pricing).permit(:price, :quantity, subtype_options: [])
  end
end
