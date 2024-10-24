require 'net/http'
require 'uri'

class FileDownloader
  def self.download_file(url, file_path)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      File.open(file_path, 'wb') do |file|
        file.write(response.body)
      end

      puts "File downloaded successfully to #{file_path}"

      return true
    else
      puts "Failed to download file: #{response.code} #{response.message}"

      return false
    end
  end
end