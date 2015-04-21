module Whitelist
  def self.filter(affiliations)
    affiliations.map(&:to_s) & Settings.affiliations.whitelist
  end

  def self.any?(affiliations)
    filter(affiliations).any?
  end
end
