namespace :gems do
  desc "Download all ruby gems"
  task download_all: :environment do
    gems = Rubygem.includes(:versions)
                  .where('versions.download_status = ?', Version::DOWNLOAD_STATUS[:not_yet])
                  .references(:versions)

    count = 0
    gems.each do |gem|
      gem.versions.each do |version|
        count += 1
        puts "Downloading: #{count} gem of Gems, Gem Name: #{gem.name}-#{version.number}"

        url = "https://rubygems.org/downloads/#{gem.name}-#{version.number}.gem"

        # Path where you want to save the downloaded file
        download_path = Rails.root.join('public', 'downloads', gem.name)
        FileUtils.mkdir_p(download_path) unless Dir.exist?(download_path)
        file_path = Rails.root.join(download_path, "#{gem.name}-#{version.number}.gem")

        if FileDownloader.download_file(url, file_path)
          version.download_status = :downloaded
          version.save!
        end
      end
    end
  end
end
