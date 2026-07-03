class LoyaltyAccountsController < ApplicationController
  before_action :set_account, only: [:show, :redeem]

  def index
    @accounts = LoyaltyAccount.all.order(points: :desc)
    @tier_filter = params[:tier]
    @accounts = @accounts.where(tier: @tier_filter) if @tier_filter.present?
  end

  def show
  end

  def new
    @account = LoyaltyAccount.new
  end

  def create
    @account = LoyaltyAccount.new(account_params)

    if @account.save
      redirect_to @account, notice: 'Conta de fidelidade criada.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def redeem
    amount = params[:amount].to_i

    if @account.redeem_points(amount)
      NotificationService.new(channel: 'sms').notify_customer(
        @account.customer_cpf,
        "Você resgatou #{amount} pontos. Saldo: #{@account.points}"
      )
      redirect_to @account, notice: 'Pontos resgatados.'
    else
      redirect_to @account, alert: 'Saldo insuficiente.'
    end
  end

  private

  def set_account
    @account = LoyaltyAccount.find(params[:id])
  end

  def account_params
    params.require(:loyalty_account).permit(:customer_cpf, :points, :tier)
  end
end
