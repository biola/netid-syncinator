module Workers
  class HandleChanges
    include Sidekiq::Worker

    class TrogdirAPIError < StandardError; end

    sidekiq_options retry: false

    def perform
      Log.info "[#{jid}] Starting job"

      hashes = []
      response = []

      loop do
        response = change_syncs.start(limit: 10).perform
        break if response.parse.blank?
        raise TrogdirAPIError, response.parse['error'] unless response.success?

        hashes += Array(response.parse)
      end

      # Keep processing batches until we run out
      changes_processed = if hashes.any?
        Log.info "[#{jid}] Processing #{hashes.length} changes"

        hashes.each do |hash|
          Workers::HandleChange.perform_async(hash)
        end
      end

      Log.info "[#{jid}] Finished job"

      # Run the worker again since there is probably more to process
      if changes_processed
        HandleChanges.perform_async
      end
    rescue StandardError => error
      Log.error "Error in HandleChanges: #{response}"
      raise error
    end

    private

    def change_syncs
      Trogdir::APIClient::ChangeSyncs.new
    end
  end
end
