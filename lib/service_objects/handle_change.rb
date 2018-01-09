module ServiceObjects
  class HandleChange < Base
    def call
      actions = []

      begin
        unless AssignNetID.ignore?(change)
          Log.info "Assigning NetID for person #{change.person_uuid}"
          actions << AssignNetID.new(change).call
        end

        action = actions.first || :skip

        if actions.empty?
          Log.info "No changes needed for person #{change.person_uuid}"
        end

        Workers::ChangeFinish.perform_async change.sync_log_id, action
      rescue StandardError => err
        Workers::ChangeError.perform_async change.sync_log_id, err.message
        Raven.capture_exception(err) if defined? Raven
      end
    end

    def ignore?
      AssignNetID.ignore?(change)
    end

    private

    def change_syncs
      Trogdir::APIClient::ChangeSyncs.new
    end
  end
end
