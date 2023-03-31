# frozen_string_literal: true

# Schedule Model
class Schedule < ApplicationRecord
  belongs_to :group

  validates :day, presence: true
  validates :time, presence: true
end
