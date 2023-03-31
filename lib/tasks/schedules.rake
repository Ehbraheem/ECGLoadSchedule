# frozen_string_literal: true

require 'csv'

namespace :seed_data do
  desc 'Seed data for schedules'
  task :schedules do
    puts 'Seeding schedules data...'
    files = Dir.glob('db/seed/schedules/*.csv')
    puts "Found #{files.count} files"

    files.each do |file|
      puts "Seeding file: #{file}"
      CSV.foreach(file, headers: true) do |row|
        if @group&.name != row['GROUP']
          @group = Group.find_or_create_by(name: row['GROUP'],
                                           description: "Group #{row['GROUP']}")
        end

        s = Schedule.find_or_create_by(day: row['DAY'], time: row['TIME'], group: @group)
        puts "Seeded schedule: #{s.day}, #{s.time}, #{s.group.name}, #{s.group.description}, #{s.id}"
      end
    end
  end
end
