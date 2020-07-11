class ProductsController < ApplicationController
  before_action :find_product, except: %i[create index]

  def index
    product_list = Product.all.select(:id, :name, :user_id).map do |product|
      product_price_list(product)
    end
    render json: { products: product_list }, status: :ok
  end

  def show
    render json: {
      product: product_object(@product)
    }, status: :ok
  end

  def create
    product = Product.new(product_params.except(:subtypes).merge(user_id: @current_user.id))
    if product.save
      create_subtypes(product)
      render json: {
        message: 'Product created successfully',
        product: product_object(product)
      }, status: :created
    else
      render json: {
        errors: product.errors.full_messages
      }, status: :bad_request
    end
  end

  def create_subtypes(product)
    product_params.except(:name)[:subtypes].each do |subtype|
      Subtype.new(name: subtype, product_id: product.id).save
    end
  end

  private

  def find_product
    @product = Product.find(params[:id])
  rescue StandardError => e
    render json: {
      errors: e.message
    }, status: :bad_request
  end

  def product_object(product)
    {
      id: product.id,
      name: product.name,
      subtypes: subtype_options(product.id)
    }
  end

  def option_price_list(pricing)
    pricing.map do |product|
      {
        id: product.id,
        price: product.price,
        quantity: product.quantity,
        subtype_options: subtype_attributes(product.subtype_options)
      }
    end
  end

  def product_price_list(product)
    {
      product_id: product.id,
      product_name: product.name,
      subtype_options: option_price_list(SubtypeOptionPricing.where(product_id: product.id).select(:id, :subtype_options, :quantity, :price))
    }
  end

  def subtype_options(product)
    subtypes = Subtype.where(product_id: product)

    subtypes.map do |subtype|
      {
        id: subtype.id,
        name: subtype.name,
        subtype_options: SubtypeOption.where(subtype_id: subtype.id).select(:id, :name)
      }
    end
  end

  def subtype_attributes(options)
    options.map do |option_id|
      subtype_attribute_object(SubtypeOption.where(id: option_id)[0])
    end
  end

  def subtype_attribute_object(option)
    {
      id: option.id,
      name: option.name,
      subtype_id: option.subtype_id,
      subtype_name: Subtype.where(id: option.subtype_id).pluck(:name)[0]
    }
  end

  def product_params
    params.require(:product).permit(:name, subtypes: [])
  end
end
