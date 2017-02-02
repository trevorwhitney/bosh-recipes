require 'yaml'
require 'json'

puts YAML.load_file("#{ENV['privates_dir']}/concourse-credentials.yml")['credentials'].to_json
