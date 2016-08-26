Tumugi.configure do |config|
  private_key_file = ENV['GCP_PRIVATE_KEY_FILE']

  config.section("bigquery") do |section|
    section.private_key_file = private_key_file
  end

  config.section("google_drive") do |section|
    section.private_key_file = private_key_file
  end
end
