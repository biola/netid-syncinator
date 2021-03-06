module ServiceObjects
  class AssignNetID < Base
    ID_TYPE = :netid

    def call
      unique_netid = UniqueNetID.new(change.preferred_name, change.last_name).get

      response = Trogdir::APIClient::IDs.new.create(uuid: change.person_uuid, identifier: unique_netid, type: ID_TYPE).perform
      if response.success?
        NetID.create(netid: unique_netid)
        :create
      else
        raise TrogdirAPIError, response.parse['error']
      end
    end

    def ignore?
      !(change.affiliation_added? && !change.netid_exists? && Whitelist.any?(change.affiliations))
    end
  end
end
