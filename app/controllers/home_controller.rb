class HomeController < ApplicationController
  def index
    @recommended_products = Product.order("RANDOM()").limit(1)
  end
end
