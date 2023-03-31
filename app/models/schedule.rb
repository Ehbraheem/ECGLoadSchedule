# frozen_string_literal: true

# Schedule Model
class Schedule < ApplicationRecord
  belongs_to :group
  belongs_to :area, inverse_of: :schedules

  validates :day, presence: true
  validates :time, presence: true
end
