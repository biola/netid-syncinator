require 'spec_helper'

describe Workers::HandleChanges do
  subject { Workers::HandleChanges.new }
  let(:success) { true }
  let(:change_syncs) { [] }

  before do
    response = double(Trogdir::APIClient::ChangeSyncs, success?: success, parse: change_syncs)
    allow_any_instance_of(Workers::HandleChanges).to receive(:loop).and_yield
    allow_any_instance_of(Workers::HandleChanges).to receive_message_chain(:change_syncs, :start, perform: response)
  end

  context 'with no change syncs' do
    it 'does not call any workers' do
      expect(Workers::HandleChange).to_not receive(:perform_async)

      subject.perform
    end
  end

  xcontext 'when a trogdir-api error' do
    let(:success) { false }
    let(:change_syncs) { {'error' => 'Oopsie!'} }

    it 'raises a TrogdirAPIError' do
      expect(Workers::HandleChange).to_not receive(:perform_async)

      expect { subject.perform }.to raise_error Workers::HandleChanges::TrogdirAPIError
    end
  end

  context 'when affiliation added' do
    let(:change_syncs) { [JSON.parse(File.read('./spec/fixtures/create_user_without_netid.json'))] }

    it 'calls AssignEmailAddress worker' do
      expect(Workers::HandleChange).to receive(:perform_async)
      expect(Workers::HandleChanges).to receive(:perform_async)

      subject.perform
    end
  end

  context 'when netid created' do
    let(:change_syncs) { [JSON.parse(File.read('./spec/fixtures/create_netid.json'))] }

    it 'calls SyncGoogleAppsAccount worker' do
      expect(Workers::HandleChange).to receive(:perform_async)
      expect(Workers::HandleChanges).to receive(:perform_async)

      subject.perform
    end
  end
end
