class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    select(:name).limit(5)
  end

  def self.dinghy
    where("length < 20")
  end

  def self.ship
    where("length >= ?", 20)
  end

  def self.last_three_alphabetically
    select(:name).order(name: :desc).limit(3)
  end

  def self.without_a_captain
    where("captain_id IS ?", nil)
  end

  def self.sailboats
    joins(:classifications).where("classifications.name" => "Sailboat")
  end

  def self.with_three_classifications
    joins(:classifications).group("boats.name").having("count(boat_id) = 3")
  end

  def self.longest
    order("length DESC").first
  end


  def self.catamaran_operators
    includes(boats: :classifications).where("classifications.name" => "Catamaran")
  end

  def self.sailors
    includes(boats: :classifications).where("classifications.name" => "Sailboat").uniq
  end

  def self.motorboaters
    includes(boats: :classifications).where("classifications.name" => "Motorboat").uniq
  end

  def self.talented_seamen
    where("id IN (?)", self.sailors.pluck(:id) & self.motorboaters.pluck(:id))
  end

  def self.non_sailors
    where.not("id IN (?)", self.sailors.pluck(:id))
  end

end
