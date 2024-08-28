class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def index
    @expenses = @group.expenses
    @users = @group.users
  end

  def new
    @users = @group.users
    @expense = Expense.new
  end

  def create
    @expense = @group.expenses.new(expense_params)
    @expense.user_id = current_user.id

    if @expense.save
      handle_expense_shares(params[:expense_shares])
      redirect_to group_expense_path(@group, @expense), notice: "Despesa criada com sucesso."
    else
      @users = @group.users
      render :new
    end
  end

  def edit
    @users = @group.users
  end

  def update
    if @expense.update(expense_params)
      update_expense_shares(params[:expense_shares])
      update_expense_payers(params[:expense_payers])
      redirect_to group_expense_path(@group, @expense), notice: "Despesa atualizada com sucesso."
    else
      @users = @group.users
      render :edit
    end
  end

  def show
    @debts = calculate_debts
    @summary = calculate_summary
  end

  def destroy
    @expense.destroy
    redirect_to group_expenses_path(@group), notice: "Despesa deletada com sucesso."
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
    expense_shares_params.each do |user_id, share_amount|
      ExpenseShare.create(expense: @expense, user_id: user_id, share_amount: share_amount.to_f)
    end
  end

  # def handle_expense_payers(expense_payers_params)
  #   expense_payers_params.each do |user_id, paid_amount|
  #     ExpensePayer.create(expense: @expense, user_id: user_id, group: @group, receiver: User.find(user_id), paid_amount: paid_amount.to_f)
  #   end
  # end

  def update_expense_shares(expense_shares_params)
    @expense.expense_shares.destroy_all
    handle_expense_shares(expense_shares_params)
  end

  def update_expense_payers(expense_payers_params)
    @expense.expense_payers.destroy_all
    handle_expense_payers(expense_payers_params)
  end

  def calculate_debts
    total_amount = @expense.amount
    shares = @expense.expense_shares.includes(:user).map { |share| [share.user, share.share_amount] }.to_h
    payers = @expense.expense_payers.includes(:user).map { |payer| [payer.user, payer.paid_amount] }.to_h

    per_person_amount = total_amount / shares.size
    debts = {}

    payers.each do |payer, paid_amount|
      owed_amount = per_person_amount - paid_amount
      debts[payer] = owed_amount if owed_amount.positive?
    end

    debts
  end

  def calculate_summary
    total_amount = @expense.amount
    shares = @expense.expense_shares.includes(:user).map { |share| [share.user, share.share_amount] }.to_h
    payers = @expense.expense_payers.includes(:user).map { |payer| [payer.user, payer.paid_amount] }.to_h

    per_person_amount = total_amount / shares.size
    summary = {}

    payers.each do |payer, paid_amount|
      summary[payer] = {
        paid: paid_amount,
        owed: (per_person_amount - paid_amount).round(2),
      }
    end

    summary
  end
end
