namespace :data do
  desc "Import list of misspelled domains."
  task import_misspelled_domains: :environment do
    # Disable noisy rake logging of individual SQL inserts
    Rails.logger.level = Logger::INFO

    File.foreach("data/misspelled_domains.txt") do |d|
      next if d[0] == "#" || d.strip.blank?

      MisspelledDomain.find_or_create_by(domain: d.strip)
    end
  end
end
