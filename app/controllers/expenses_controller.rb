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
        process_expense_shares(params[:expense_shares])
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

  def valid_shares?(expense_shares_params)
    total_amount = expense_params[:amount].to_f
    total_shares = expense_shares_params.values.map { |data| data["amount"].to_f if data["selected"] == "1" && data["amount"].present? }
    total_amount == total_shares.compact.sum
  end

  def process_expense_shares(expense_shares_params)
    expense_shares_params.each do |user_id, share_data|
      if share_data["amount"].blank?
        share_data["amount"] = "0"
      end
    end

    selected_shares = expense_shares_params.values.select do |data|
      data["selected"] == "1" && data["amount"].present?
    end

    total_amount = @expense.amount.to_f
    num_selected_users = selected_shares.size
    per_person_amount = num_selected_users > 0 ? total_amount / num_selected_users : 0

    ExpenseShare.where(expense: @expense).destroy_all

    expense_shares_params.each do |user_id, share_data|
      next unless share_data["selected"] == "1"

      share_amount = share_data["amount"].to_f

      ExpenseShare.create(
        expense: @expense,
        user_id: user_id.to_i,
        share_amount: share_amount,
        per_person_amount: per_person_amount
      )
    end
  end
end
