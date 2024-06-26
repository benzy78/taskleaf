class Task < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :name, length: {maximum: 30}
  validate :validate_name_not_including_comma

  belongs_to :user

# スコープの定義:デフォルトでは、recentがundefineになった。
  scope :recent, -> { order(created_at: :desc) }
 # 検索可能な属性を定義:下記を明記しないとエラーになった
 def self.ransackable_attributes(auth_object = nil)
  ["created_at", "description", "id", "name", "updated_at", "user_id"]
end

  private
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません')if name&.include?(',')
  end
end
