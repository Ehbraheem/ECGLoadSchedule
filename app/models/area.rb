# frozen_string_literal: true

# Area Model
class Area < ApplicationRecord
  belongs_to :group, inverse_of: :areas
  has_many :schedules, through: :group, inverse_of: :area

  validates :name, presence: true
  validates :group, presence: true
  validates :region, presence: true

  before_save :create_simple_searchable_column

  scope :by_name, ->(name) { where('simple_search_field ILIKE ?', "%#{name}%") }
  scope :by_region, ->(region) { where('region ILIKE ?', "%#{region}%") }
  scope :by_group_name, ->(group_name) { joins(:group).where('groups.name ILIKE ?', "%#{group_name}%") }

  class << self
    def search(params)
      areas = all
      areas = areas.by_name(params[:name]) if params[:name].present?
      areas = areas.by_region(params[:region]) if params[:region].present?
      areas = areas.by_group_name(params[:group_name]) if params[:group_name].present?
      areas
    end
  end

  private

  def create_simple_searchable_column
    self.simple_search_field = "#{name} #{region}"
  end
end
