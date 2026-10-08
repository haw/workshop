class Timestamp::Form
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :prefix, :string
  attribute :content, :string

  validates :content, presence: true
  validate :check_bytesize

  def initialize(params = {})
    super(params)
  end

  private

  def check_bytesize
    errors.add(:content, 'は127バイト以下にしてください') if content.to_s.bytesize > 127
    errors.add(:prefix, 'は10バイト以下にしてください') if prefix.to_s.bytesize > 10
  end
end
