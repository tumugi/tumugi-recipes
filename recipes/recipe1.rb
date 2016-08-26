####################################################
# Recipe1: Download file and save it as local file
#
# https://tumugi.github.io/recipe1/
#
# 1. Download archived daily access logs from
#    remote servers using wget command
# 2. Count number of rows group by URI and
#    save result into CSV file
####################################################

require 'ltsv'
require 'zip'

####################################################
# 1. Archived log download
####################################################

task :download_log, type: :command do
  param :host, default: 'https://tumugi.github.io'
  param :log_filename, type: :string
  param :day, auto_bind: true, type: :time, required: true # <= This value is auto binding from CLI parameter

  log_filename {
    "access_#{day.strftime('%Y%m%d')}.log.zip"
  }
  command {
    url = "#{host}/data/#{log_filename}"
    "wget #{url} -O #{output.path}"
  }

  output {
    target(:local_file, "tmp/#{log_filename}")
  }
end

####################################################
# 2. Count rows group by URI
####################################################

task :count_rows_group_by_uri do
  requires :download_log
  output target(:local_file, '/tmp/result.csv')
  run {
    counts = {}
    log input.path
    Zip::File.open(input.path) do |zip_file|
      zip_file.each do |entry|
        entry.get_input_stream.each do |line|
          values = LTSV.parse(line).first
          counts[values[:uri]] ||= 0
          counts[values[:uri]] += 1
        end
      end
    end
    output.open('w') do |o|
      counts.each do |k, v|
        o.puts "#{k},#{v}"
      end
    end
  }
end

####################################################
# Main Task
####################################################

task :main do
  requires :count_rows_group_by_uri
  run {
    log File.read(input.path)
  }
end
