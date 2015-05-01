require 'spec_helper'

describe TrogdirChange do
  let(:hash) { JSON.parse(File.read('./spec/fixtures/create_user.json')) }
  subject { TrogdirChange.new(hash) }

  describe '#sync_log_id' do
    it { expect(subject.sync_log_id).to eql '000000000000000000000000'}
  end

  describe '#person_uuid' do
    it { expect(subject.person_uuid).to eql '00000000-0000-0000-0000-000000000000'}
  end

  describe '#preferred_name' do
    context 'without a preferred name' do
      let(:hash) { JSON.parse(File.read('./spec/fixtures/create_user_without_netid.json')) }
      it { expect(subject.preferred_name).to eql 'Robert'}
    end

    context 'with a preferred name' do
      it { expect(subject.preferred_name).to eql 'Bob'}
    end
  end

  describe '#last_name' do
    it { expect(subject.last_name).to eql 'Dole'}
  end

  describe '#affiliations' do
    it { expect(subject.affiliations).to eql ['employee']}
  end

  describe '#netid_exists?' do
    context 'with a netid' do
      it { expect(subject.netid_exists?).to be true }
    end

    context 'without a netid' do
      let(:hash) { JSON.parse(File.read('./spec/fixtures/create_user_without_netid.json')) }

      it { expect(subject.netid_exists?).to be false }
    end
  end

  describe '#affiliation_added?' do
    context 'when creating a person with affiliations' do
      it { expect(subject.affiliation_added?).to be true }
    end

    context 'when creating an id' do
      let(:hash) { JSON.parse(File.read('./spec/fixtures/create_netid.json')) }

      it { expect(subject.affiliation_added?).to be false }
    end

    context 'when updating a person but not changing affiliations' do
      let(:hash) { JSON.parse(File.read('./spec/fixtures/update_person.json')) }

      it { expect(subject.affiliation_added?).to be false }
    end
  end
end
