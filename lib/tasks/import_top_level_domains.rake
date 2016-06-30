namespace :data do
  desc "Import list of top-level domains."
  task import_top_level_domains: :environment do
    # Disable noisy rake logging of individual SQL inserts
    Rails.logger.level = Logger::INFO

    File.foreach("data/tlds-alpha-by-domain.txt") do |d|
      next if d[0] == "#" || d.strip.blank?

      TopLevelDomain.find_or_create_by(domain: d.strip)
    end
  end
end
