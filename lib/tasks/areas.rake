# frozen_string_literal: true

require 'csv'

namespace :seed_data do
  desc 'Seed data for areas'
  task :areas do
    puts 'Seeding areas data...'
    files = Dir.glob('db/seed/areas/*.csv')
    puts "Found #{files.count} files"

    files.each do |file|
      puts "Seeding file: #{file}"
      CSV.foreach(file, headers: true) do |row|
        if @group&.name != row['GROUP']
          @group = Group.find_or_create_by(name: row['GROUP'],
                                           description: "Group #{row['GROUP']}")
        end

        csv_areas = row['AREAS'].split(',').map(&:strip)

        csv_areas.each do |area|
          a = Area.find_or_create_by(name: area, region: row['REGION'], group: @group)
          puts "Seeded area: #{a.name}, #{a.region}, #{a.group.name}, #{a.group.description}, #{a.id}"
        end

        puts "Seeded #{csv_areas.count} areas"
      end
    end
  end
end
