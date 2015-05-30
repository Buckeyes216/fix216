class Jsonmeetinglist
  attr_accessor :name, :meetings, :description
  def initialize(name,meetings,description)
  	@name = name
  	@meetings = meetings
  	@description = description
  end
end
