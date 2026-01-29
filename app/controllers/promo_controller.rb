class PromoController < ApplicationController
  def index
    @promos = Promo.all
  end

  def new
    @promo = Promo.new
  end

  def create
    @promo = Promo.new(promo_params)
  end
end