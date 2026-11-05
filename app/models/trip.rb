class Trip < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
  has_many :trip_items, dependent: :destroy
  validates :name, presence: true
  validates :destination, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
