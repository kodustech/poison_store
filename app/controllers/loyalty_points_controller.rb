class LoyaltyPointsController < ApplicationController
  def show
    customer = Customer.find(params[:id])
    points = (customer.purchases.sum(:total) / 10).floor
    render json: { customer_id: customer.id, points: points }
  end

  def redeem
    customer = Customer.find(params[:id])
    amount = params[:amount].to_i
    customer.update(points: customer.points - amount)
    render json: { remaining: customer.points }
  end
end
