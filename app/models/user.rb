class User < ApplicationRecord
  has_rich_text :body
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :email, presence: true
  validates_presence_of :name

  def self.to_csv(options = {})
    attributes = User.column_names
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  def self.import(file)
    if file.content_type == "text/csv"
      spreadsheet = Roo::CSV.new(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |row_num|
        row = spreadsheet.row(row_num)
        if row[3] == "email"
          next
        else
          User.create!(name: row[1], email: row[2])
        end
      end
    else
      spreadsheet = Roo::Spreadsheet.open(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        user = find_by_id(row["id"]) || new
        user.attributes = row.to_hash.slice(*row.to_hash.keys)
        user.save!
      end
    end
  end

  # def self.open_spreadsheet(file)
  #   case File.extname(file.original_filename)
  #   when ".csv" then Roo::CSV.new(file.path, packed: false, file_warning: :ignore)
  #   when ".xls" then Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
  #   when ".xlsx" then Roo::Excelx.new(file.path, packed: false, file_warning: :ignore)
  #   else raise "Unknown file type: #{file.original_filename}"
  #   end
  # end
end
