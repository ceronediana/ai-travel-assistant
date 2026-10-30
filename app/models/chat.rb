class Chat < ApplicationRecord
  belongs_to :trip
  belongs_to :user
  has_many :messages, dependent: :destroy
end
