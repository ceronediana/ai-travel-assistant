class TripItem < ApplicationRecord
  belongs_to :trip
  acts_as_taggable_on :tag
end
