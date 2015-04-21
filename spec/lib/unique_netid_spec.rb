require 'spec_helper'

describe UniqueNetID do
  let(:first_name) { 'Bob' }
  let(:last_name) { 'Dole' }
  subject { UniqueNetID.new(first_name, last_name) }

  context 'when available' do
    before { allow_any_instance_of(NetID).to receive(:available?).and_return true }

    it 'does not append a number' do
      expect(subject.get).to eql 'bobd'
    end
  end

  context 'when some are taken' do
    before do
      allow(NetID).to receive(:new).with('bobd').and_return instance_double(NetID, available?: false)
      allow(NetID).to receive(:new).with('bobd1').and_return instance_double(NetID, available?: false)
      allow(NetID).to receive(:new).with('bobd2').and_return instance_double(NetID, available?: true)
    end

    it 'appends a number' do
      expect(subject.get).to eql 'bobd2'
    end
  end
end
