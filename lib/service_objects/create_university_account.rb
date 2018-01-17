module ServiceObjects
  class CreateUniversityAccount < Base
    ACCOUNT_TYPE = 'UniversityAccount'.freeze

    def call
      response = Trogdir::APIClient::Account.new.create(
        uuid: change.person_uuid, _type: ACCOUNT_TYPE
      ).perform
      rails TrogdirAPIError, response.parse['error'] unless response.success?
      :create
    end

    def ignore?
      !(change.affiliation_added? &&
        !change.netid_exists? &&
        Whitelist.any?(change.affiliations))
    end
  end
end
