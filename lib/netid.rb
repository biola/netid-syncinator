class NetID
  class TrogdirAPIError < StandardError; end

  include Mongoid::Document
  include Mongoid::Timestamps

  field :netid, type: String

  validates :netid, presence: true
end
