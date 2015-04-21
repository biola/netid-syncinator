class TrogdirChange
  attr_reader :hash

  def initialize(hash)
    @hash = hash
  end

  def sync_log_id
    hash['sync_log_id']
  end

  def person_uuid
    hash['person_id']
  end

  def preferred_name
    all_attrs['preferred_name']
  end

  def last_name
    all_attrs['last_name']
  end

  def affiliations
    all_attrs['affiliations']
  end

  def netid_exists?
    Array(all_attrs['ids']).any? { |id| id['type'] == 'netid' }
  end

  def affiliation_added?
    person? && (create? || update?) && affiliations_changed?
  end

  private

  def person?
    hash['scope'] == 'person'
  end

  def id?
    hash['scope'] == 'id'
  end

  def create?
    hash['action'] == 'create'
  end

  def update?
    hash['action'] == 'update'
  end

  def affiliations_changed?
    changed_attrs.include?('affiliations')
  end

  def changed_attrs
    @changed_attrs ||= (original.keys + modified.keys).uniq
  end

  def original
    hash['original']
  end

  def modified
    hash['modified']
  end

  def all_attrs
    hash['all_attributes']
  end
end
