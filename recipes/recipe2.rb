####################################################
# Recipe2: Export BigQuery query result to
#          Google Drive and notify URL to Slack
#
# https://tumugi.github.io/recipe2/
#
# 1. Execute query on BigQuery and save result to table
# 2. Export table to Google Drive
# 3. Notify Google Drive URL to Slack
####################################################

####################################################
# 1. Execute query on BigQuery and save result to table
####################################################

task :create_dataset, type: :bigquery_dataset do
  dataset_id "tmp"
end

task :run_query, type: :bigquery_query do
  requires :create_dataset

  dataset_id { input.dataset_id }
  table_id   "dest_table_#{Time.now.strftime("%Y%m%d%H%M%S")}"
  query <<~SQL
    SELECT
      word,
      word_count
    FROM
      publicdata:samples.shakespeare
    WHERE
      corpus = "hamlet"
    ORDER BY
      word_count DESC
    LIMIT
      100
  SQL
end

####################################################
# 2. Export table to Google Drive
####################################################

task :export_to_google_drive, type: :bigquery_export do
  requires :run_query

  dataset_id { input.dataset_id }
  table_id   { input.table_id }

  output {
    target  :google_drive_file,
            name: "#{input.table_id}.csv",
            parents: ENV['GOOGLE_DRIVE_FOLDER_ID'],
            mime_type: "application/vnd.google-apps.spreadsheet"
  }
end

####################################################
# 3. Notify Google Drive URL to Slack
####################################################

task :notify_to_slack, type: :webhook do
  requires :export_to_google_drive

  url ENV['SLACK_WEBHOOK_URL']
  body { { text: "#{input.name} export success.\n<#{input.url}|Click here> to get file" } }
end

####################################################
# Main Task
####################################################

task :main do
  requires :notify_to_slack
  run { log "Finished" }
end
