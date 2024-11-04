require 'net/http'
require 'uri'
require 'concurrent'

class DownloadGem
  def self.call
    gems = Rubygem.includes(:versions)
                  .where('versions.download_status = ?', Version::DOWNLOAD_STATUS[:not_yet])
                  .references(:versions)
		  .order(:gem_full_name)

    gems.each { | gem | download_gem(gem) }
  end

  def self.download_gem(gem)
    # Define the list of URLs to download (ensuring uniqueness)
    versions = Set.new(gem.versions.collect { |version| [gem, version] })

    download_versions(versions)
  end

  # Download all gems that not downloaded yet.
  def self.download_versions(versions)
    # Mutex to manage download status and avoid duplicates
    mutex = Mutex.new
    downloaded_files = Set.new

    # Define a ThreadPoolExecutor with a limited number of threads
    executor = Concurrent::ThreadPoolExecutor.new(
      min_threads: 20,       # Minimum number of threads to keep alive
      max_threads: 30,      # Maximum number of concurrent threads
      max_queue: 50,        # Maximum number of tasks in the queue before rejecting new ones
      fallback_policy: :caller_runs # Strategy for handling rejected tasks
    )

    # Use Concurrent::Future to handle downloads in parallel
    futures = versions.map do |version_info|
      executor.post do
        mutex.synchronize do
          next if downloaded_files.include?(version_info)     # Skip if already downloaded
          downloaded_files.add(version_info)                  # Mark as downloading to prevent duplicates
        end

        # Perform the download
        download_version(version_info)
      end
    end

    # Shut down the executor and wait for tasks to finish
    executor.shutdown
    executor.wait_for_termination
    puts "All downloads complete."
  end

  # Download a version of the gem
  def self.download_version(version_info)
    gem = version_info[0]
    gem_name = gem.name
    version = version_info[1]
    version_number = version.number

    # Set up a directory for downloaded files
    download_dir = Rails.root.join('public', 'downloads', gem_name)
    FileUtils.mkdir_p(download_dir) unless Dir.exist?(download_dir)
    file_path = Rails.root.join('public', 'downloads', gem_name, "#{gem_name}-#{version_number}.gem")

    url = "https://rubygems.org/downloads/#{gem_name}-#{version_number}.gem"
    uri = URI(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      File.open(file_path, 'wb') do |file|
        file.write(response.body)
      end

      puts "Downloaded: #{gem_name}-#{version_number}.gem"
      version.download_status = Version::DOWNLOAD_STATUS[:downloaded]
      version.save!
    else
      puts "Failed: #{gem_name}-#{version_number}.gem"
      version.download_status = Version::DOWNLOAD_STATUS[:processed]
      version.save!
    end
  rescue => e
    puts "Error downloading #{url}: #{e.message}"
  end
end
