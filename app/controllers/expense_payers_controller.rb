class ExpensePayersController < ApplicationController
  before_action :set_group

  def new
    @expense_payer = ExpensePayer.new
    @users = @group.users
  end

  def create
    @expense_payer = ExpensePayer.new(expense_payer_params)
    @expense_payer.group = @group
    @expense_payer.user = current_user

    if @expense_payer.save
      redirect_to @group, notice: "Pagamento adicionado com sucesso."
    else
      @users = @group.users
      render :new
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def expense_payer_params
    params.require(:expense_payer).permit(:paid_amount, :description, :receiver_id)
  end
end
