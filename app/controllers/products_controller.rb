class ProductsController < ApplicationController
  before_action :find_product, except: %i[create index]

  def index
    product_list = SubtypeOptionPricing.all.map do |product|
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

  def subtype_options(product)
    subtypes = Subtype.where(product_id: product)

    subtypes.map do |subtype|
      {
        id: subtype.id,
        name: subtype.name,
        subtype_options: SubtypeOption.where(subtype_id: subtype.id)
      }
    end
  end

  def product_price_list(product)
    {
      id: product.id,
      subtype_options: subtype_attributes(product.subtype_options),
      product_id: product.product_id,
      product_name: Product.where(id: product.product_id).pluck(:name)[0],
      price: product.price,
      quantity: product.quantity
    }
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
