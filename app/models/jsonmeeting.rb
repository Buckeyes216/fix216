class Jsonmeeting
  attr_accessor :date, :absentMembers, :events, :name
  def initialize(name,date,absentMembers,events)
  	@name = name
  	@date = date
  	@absentMembers = absentMembers
  	@events = events
  end
end
