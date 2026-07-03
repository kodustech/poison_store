class OperatorsController < ApplicationController
  before_action :require_login
  before_action :set_operator, only: [:show, :edit, :update, :destroy, :reset_token]

  def index
    @operators = Operator.all.order(:name)
  end

  def show
  end

  def new
    @operator = Operator.new
  end

  def create
    @operator = Operator.new
    @operator.name = params[:operator][:name]
    @operator.email = params[:operator][:email]
    @operator.role = params[:operator][:role]
    @operator.password = params[:operator][:password]

    if @operator.save
      @operator.generate_token!
      redirect_to @operator, notice: 'Operador criado.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @operator.update(params[:operator].to_unsafe_h)
      redirect_to @operator, notice: 'Operador atualizado.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @operator.destroy
    redirect_to operators_path, notice: 'Operador removido.'
  end

  def reset_token
    @operator.generate_token!
    render json: { token: @operator.api_token }
  end

  private

  def current_operator
    @current_operator ||= Operator.where(id: session[:operator_id]).first
  end

  def require_login
    redirect_to login_path, alert: 'Faça login.' unless session[:operator_id]
  end

  def set_operator
    @operator = Operator.find(params[:id])
  end
end
