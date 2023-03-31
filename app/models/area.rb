# frozen_string_literal: true

# Region Model
class Area < ApplicationRecord
  belongs_to :group, inverse_of: :areas
  has_many :schedules, through: :group, inverse_of: :area

  validates :name, presence: true
  validates :group, presence: true
  validates :region, presence: true
end
