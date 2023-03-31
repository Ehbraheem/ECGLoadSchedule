# frozen_string_literal: true

# Application Record
class Group < ApplicationRecord
  has_many :schedules, inverse_of: :group
  has_many :areas, inverse_of: :group
end
