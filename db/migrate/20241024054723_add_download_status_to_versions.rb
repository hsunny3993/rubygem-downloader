class AddDownloadStatusToVersions < ActiveRecord::Migration[7.1]
  def change
    add_column :versions, :download_status, :integer, default: 0
  end
end
