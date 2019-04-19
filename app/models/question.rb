class Question < ApplicationRecord

  belongs_to :user

  validates :text, :user, presence: true
  validates :text, length: {maximum: 255, message: "Превышен лимит символов (не более 255)"}



end
