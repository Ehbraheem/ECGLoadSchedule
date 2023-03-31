# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'rake'

# Seed Data Migration
class SeedData < ActiveRecord::Migration[7.0]
  def up
    run_rake_task 'seed_data:schedules'
    run_rake_task 'seed_data:areas'
  end

  def down
    Group.destroy_all
    Area.destroy_all
    Schedule.destroy_all
  end

  private

  def run_rake_task(task)
    Rake::Task[task].reenable
    Rake::Task[task].invoke
  end
end
