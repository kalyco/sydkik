require "csv"

namespace :data do
  desc "Import zip code data."
  task import_zipcodes: :environment do
    # Disable noisy rake logging of individual SQL inserts
    Rails.logger.level = Logger::INFO

    # Load the metro->zip map into memory
    metros = {}
    CSV.foreach("data/metros.csv", headers: false) do |row|
      metros[row[0]] = row[1]
    end

    zipcodes = []

    CSV.foreach("data/zipcodes/swt-us-commercial-full.csv", headers: true) do |row|
      # Only use the preferred city name
      next if row[8] != "A"

      metro = Metro.find_or_create_by(name: metros[row[0]]) if metros[row[0]]

      zip = [format("%05d", row[0].to_i), # zip
             row[6],                      # lat
             row[7],                      # long
             row[2].titleize,             # city
             row[1],                      # state
             row[3],                      # county
             metro.try(:id)]              # metro_id

      zipcodes << zip
    end

    ActiveRecord::Base.connection.execute("CREATE TABLE zipcodes_new ( LIKE zipcodes INCLUDING DEFAULTS INCLUDING INDEXES )")

    pgconn = Zipcode.connection.raw_connection
    enco = PG::TextEncoder::CopyRow.new
    times = [Time.zone.now.to_s] * 2
    pgconn.copy_data("COPY zipcodes_new (zip, lat, long, city, state, county, metro_id, created_at, updated_at) FROM STDIN", enco) do
      zipcodes.each do |row|
        pgconn.put_copy_data(row + times)
      end
    end

    ActiveRecord::Base.connection.execute("BEGIN;
ALTER TABLE zipcodes RENAME TO zipcodes_old;
ALTER TABLE zipcodes_new RENAME TO zipcodes;
ALTER SEQUENCE zipcodes_id_seq OWNED BY zipcodes.id;
DROP TABLE zipcodes_old CASCADE;
COMMIT;")

    # In QA, staging, or prod, restore readonly access to the table
    unless Rails.env.development? || Rails.env.test?
      ActiveRecord::Base.connection.execute("GRANT SELECT ON TABLE \"zipcodes\" TO \"readonly\";")
    end
  end
end
