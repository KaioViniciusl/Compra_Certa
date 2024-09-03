class UserGroup < ApplicationRecord
  before_save :downcase_user_mail
  belongs_to :user, optional: true
  belongs_to :group

  validates :invite_accepted, inclusion: { in: [true, false] }

  private

  def downcase_user_mail
    self.user_mail = user_mail.downcase
  end
end
