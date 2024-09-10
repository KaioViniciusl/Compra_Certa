class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_expense, only: [:show, :update, :destroy]

  def index
    @expenses = @group.expenses.order(:date)
    @user_balances = calculate_user_balances
  end

  def new
    @expense = Expense.new
    @users = @group.users
  end

  def create
    @expense = @group.expenses.new(expense_params)
    @expense.user = current_user

    if @expense.save
      if valid_shares?(params[:expense_shares])
        process_expense_shares(params[:expense_shares])
        redirect_to group_path(@group), notice: "Sua despesa foi criada."
      else
        @expense.destroy
        flash[:alertgroup] = "Os valores inseridos não correspondem ao valor total da despesa."
        redirect_to new_group_expense_path(@group)
      end
    else
      flash[:alertgroup] = "Houve algum erro. Por favor, preencha os campos abaixo e não se esqueça de selecionar os usuários."
      redirect_to new_group_expense_path(@group)
    end
  end

  def update
    if @expense.update(expense_params)
      if valid_shares?(params[:expense_shares])
        handle_expense_shares(params[:expense_shares])
        redirect_to group_expense_path(@group, @expense), notice: "Sua despesa foi atualizada."
      else
        flash[:alertgroup] = "Os valores inseridos não correspondem ao valor total da despesa."
        render :edit
      end
    else
      render :edit
    end
  end

  def show
    @debts = @group.calculate_owed_amounts_with_payments
  end

  def destroy
    @expense.destroy
    @group.user_groups.each(&:update_credit_and_debit)
    redirect_to group_path(@group), notice: "Sua despesa foi removida."
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_expense
    @expense = @group.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:name_expense, :description, :date, :amount)
  end

  def handle_expense_shares(expense_shares_params)
    return unless expense_shares_params.is_a?(Hash)

    ExpenseShare.where(expense: @expense).destroy_all

    expense_shares_params.each do |user_id, share_amount|
      ExpenseShare.create(expense: @expense, user_id: user_id.to_i, share_amount: share_amount.to_f)
    end
  end

  def valid_shares?(expense_shares_params)
    total_amount = expense_params[:amount].to_f
    total_shares = expense_shares_params.values.sum { |data| data["amount"].to_f if data["selected"] == "1" }
    total_amount == total_shares
  end

  def process_expense_shares(expense_shares_params)
    expense_shares_params.each do |user_id, share_data|
      next unless share_data["selected"] == "1"

      ExpenseShare.create(
        expense: @expense,
        user_id: user_id.to_i,
        share_amount: share_data["amount"].to_f,
      )
    end
  end
end
