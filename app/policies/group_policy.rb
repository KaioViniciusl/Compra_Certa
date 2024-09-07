class GroupPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def accept_invite?
    true
  end

  def update?
    user.present? && user_is_owner?
  end

  def destroy?
    user.present? && user_is_owner?
  end

  private

  def user_is_owner?
    record.user == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user
        scope.joins(:user_groups)
             .where("user_groups.user_id = ? AND user_groups.invite_accepted = ?", user.id, true)
             .distinct
      else
        scope.none
      end
    end
  end
end
