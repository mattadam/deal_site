require "#{Rails.root}/lib/tasks/publisher_importer"

namespace :import do
  desc "Import data pass in file and publisher name"
  task :deals ,:file ,:publisher_name do |t,args|
    PublisherImporter.import(args[:file],args[:publisher_name])
  end
end