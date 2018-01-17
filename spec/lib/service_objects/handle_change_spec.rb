require 'spec_helper'

describe ServiceObjects::HandleChange do
  subject { ServiceObjects::HandleChange.new(change) }
  let(:change_hash) { JSON.parse(File.read('./spec/fixtures/create_user.json')) }
  let(:change) { TrogdirChange.new(change_hash) }

  context 'when biola_id created' do
    let(:change_hash) { JSON.parse(File.read('./spec/fixtures/create_biola_id.json')) }

    it 'does not call any service objects' do
      expect_any_instance_of(ServiceObjects::AssignNetID).to_not receive(:call)
      expect_any_instance_of(ServiceObjects::CreateUniversityAccount).to_not receive(:call)
      expect(Workers::ChangeFinish).to receive(:perform_async).with(kind_of(String), :skip)
      expect(Workers::ChangeError).to_not receive(:perform_async)

      subject.call
    end
  end

  context 'when affiliation added' do
    let(:change_hash) { JSON.parse(File.read('./spec/fixtures/create_user_without_netid.json')) }

    it 'calls AssignNetID and CreateUniversityAccount' do
      expect_any_instance_of(ServiceObjects::AssignNetID).to receive(:call).and_return(:create)
      expect_any_instance_of(ServiceObjects::CreateUniversityAccount).to receive(:call).and_return(:create)
      expect(Workers::ChangeFinish).to receive(:perform_async).with(kind_of(String), :create)
      expect(Workers::ChangeError).to_not receive(:perform_async)

      subject.call
    end
  end

  context 'when netid created' do
    let(:change_hash) { JSON.parse(File.read('./spec/fixtures/create_netid.json')) }

    it 'calls SyncGoogleAccount' do
      expect_any_instance_of(ServiceObjects::AssignNetID).to_not receive(:call)
      expect_any_instance_of(ServiceObjects::CreateUniversityAccount).to_not receive(:call)
      expect(Workers::ChangeFinish).to receive(:perform_async).with(kind_of(String), :skip)
      expect(Workers::ChangeError).to_not receive(:perform_async)

      subject.call
    end
  end
end
