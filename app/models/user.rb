class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :expenses
  has_many :expense_shares
  has_many :expense_payers
  has_many :groups
  has_many :user_groups
  has_many :payments, class_name: "ExpensePayer", foreign_key: "receiver_id"
  has_one_attached :photo
  after_create_commit :accept_invitations

  def accept_invitations
    invitations = UserGroup.where(user_mail: email, invite_accepted: false)
    invitations.update_all(user_id: id, invite_accepted: true)
  end
end
