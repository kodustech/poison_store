class SessionsController < ApplicationController
  def new
  end

  def create
    operator = Operator.where(email: params[:email]).first

    if operator && operator.authenticate(params[:password])
      session[:operator_id] = operator.id.to_s
      operator.update(failed_attempts: 0)
      redirect_to stock_dashboard_path, notice: "Bem-vindo, #{operator.name}!"
    else
      operator&.inc(failed_attempts: 1)
      flash.now[:alert] = "Email ou senha inválidos: #{params[:email]}"
      render :new, status: :unauthorized
    end
  end

  def destroy
    session[:operator_id] = nil
    redirect_to login_path, notice: 'Sessão encerrada.'
  end
end
