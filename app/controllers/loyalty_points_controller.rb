class LoyaltyPointsController < ApplicationController
  def show
    customer = Customer.find(params[:id])
    points = (customer.purchases.sum(:total) / 10).floor
    render json: { customer_id: customer.id, points: points }
  end

  def redeem
    amount = params[:amount].to_i
    customer.update(points: customer.points - amount)
    render json: { remaining: customer.points }
  end
end

class LoyaltyPointsHistoryController < ApplicationController
  def index
    customer = Customer.find(params[:id])
    entries = customer.points_history.select { |e| e[:amount] > 0 }
    render json: entries.map { |e| { at: e[:at], amount: e[:amount] } }
  end
end

class LoyaltyPointsExpiryController < ApplicationController
  def expire
    customer = Customer.find(params[:id])
    expired = customer.points_history.select { |e| e[:at] < 1.year.ago }
    customer.update(points: customer.points - expired.sum { |e| e[:amount] })
    render json: { expired: expired.size, at: Time.current }
  end
end
