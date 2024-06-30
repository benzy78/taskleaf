class Task < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :name, length: {maximum: 30}
  validate :validate_name_not_including_comma

  belongs_to :user
  has_one_attached :image

# スコープの定義:デフォルトでは、recentがundefineになった。
  scope :recent, -> { order(created_at: :desc) }
 # 検索可能な属性を定義:下記を明記しないとエラーになった
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at", "user_id"]
  end
 
  # Ransackに対して、このモデルのアソシエーションは検索対象としない
  def self.ransackable_associations(auth_object = nil)
    []
  end

  # CSV形式のファイルのexport
  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end
  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{|attr| task.send(attr)}
      end
    end
  end

  #CSV形式のファイルのimport
  def self.import(file)
    CSV.foreach(file.path, encoding: 'ISO-8859-1:UTF-8', headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  # rescue CSV::MalformedCSVError => e
  #   puts "CSVファイルの形式が正しくありません: #{e.message}"
  end


  private
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません')if name&.include?(',')
  end
end