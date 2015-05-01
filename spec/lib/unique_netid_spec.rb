require 'spec_helper'

describe UniqueNetID do
  let(:first_name) { 'Bob' }
  let(:last_name) { 'Dole' }
  subject { UniqueNetID.new(first_name, last_name) }

  context 'when available' do
    before { allow_any_instance_of(NetID).to receive(:where).and_return [] }

    it 'does not append a number' do
      expect(subject.get).to eql 'bobd'
    end
  end

  context 'when some are taken' do
    before do
      allow(NetID).to receive(:where).with(netid: 'bobd').and_return [NetID.new]
      allow(NetID).to receive(:where).with(netid: 'bobd1').and_return [NetID.new]
      allow(NetID).to receive(:where).with(netid: 'bobd2').and_return []
    end

    it 'appends a number' do
      expect(subject.get).to eql 'bobd2'
    end
  end
end
