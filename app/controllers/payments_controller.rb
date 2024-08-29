class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.group = @group

    if @payment.save
      redirect_to @group, notice: "Pagamento criado com sucesso."
    else
      render :new
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :description, :paid_by_id, :receiver_id)
  end
end
