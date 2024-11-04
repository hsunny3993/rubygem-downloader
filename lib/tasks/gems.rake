namespace :gems do
  desc "Download all ruby gems"
  task download_all: :environment do
    DownloadGem::call
  end
end
