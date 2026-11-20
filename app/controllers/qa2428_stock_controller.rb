class Qa2428StockController < ApplicationController
  def show
    customer = Customer.find(params[:id])
    points = customer.purchases.sum(:total) * 0.05
    render json: { points: points, status: 3 }
  end
end
