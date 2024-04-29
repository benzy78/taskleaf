class Task < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :name, length: {maximum: 30}
  validate :validate_name_not_including_comma

  private
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません')if name&.include?(',')
  end
  # 上記のエラーメッセージが出力されない
end
