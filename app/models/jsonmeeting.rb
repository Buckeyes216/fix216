class Jsonmeeting
  attr_accessor :date, :absentMembers, :events, :name, :publiccomment
  def initialize(name,date,absentMembers,events,publiccomment)
  	@name = name
  	@date = date
  	@absentMembers = absentMembers
  	@events = events
  	@publiccomment = publiccomment
  end
end
