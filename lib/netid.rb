class NetID
  class TrogdirAPIError < StandardError; end

  attr_reader :netid

  def initialize(netid)
    @netid = netid
  end

  def available?
    # TODO: check a local database instead of trogdir.
    # This will prevent us from reusing NetIDs that have been renamed or deleted.
    response = Trogdir::APIClient::People.new.by_id(id: netid, type: :netid).perform
    raise TrogdirAPIError, response.parse['error'] if response.server_error?

    response.status == 404
  end
end
