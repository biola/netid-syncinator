class UniqueNetID
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    raise ArgumentError, "first_name can't be blank" if first_name.blank?
    raise ArgumentError, "last_name can't be blank" if last_name.blank?

    @first_name = first_name
    @last_name = last_name
  end

  def get
    netid = nil

    # If the base is not available append a number
    while netid.nil?
      i ||= nil
      try_netid = "#{netid_base}#{i}"

      if NetID.where(netid: try_netid).none?
        netid = try_netid
        break
      end

      raise 'loop went on for too long' if i.to_i > 1000

      i = i.to_i + 1
    end

    netid
  end

  private

  def last_initial
    last_name.to_s[0]
  end

  def netid_base
    "#{first_name}#{last_initial}".downcase.gsub(/[^a-z]/, '')
  end
end
