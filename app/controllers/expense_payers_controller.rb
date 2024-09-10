class ExpensePayersController < ApplicationController
  before_action :set_group

  def new
    @expense_payer = ExpensePayer.new
    @group = Group.find(params[:group_id])
    @users = @group.users.to_a.reject { |user| user.id == current_user.id }
  end

  def create
    @expense_payer = ExpensePayer.new(expense_payer_params)
    @expense_payer.group = @group
    @expense_payer.user = current_user

    if @expense_payer.save
      redirect_to @group, notice: "Pagamento adicionado com sucesso."
    else
      # @users = @group.users
      flash[:alertgroup] = "Houve algum erro. Por favor, preencha os campos abaixo e não se esqueça de selecionar uma data."
      redirect_to new_group_expense_payer_path(@group)
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def expense_payer_params
    params.require(:expense_payer).permit(:paid_amount, :description, :receiver_id, :date)
  end
end
