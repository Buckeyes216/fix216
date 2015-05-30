class WelcomeController < ApplicationController
  def index
  	@lines = params[:lines]
  	@resolutions = params[:resolutions]
  end
  def upload
  	file = params[:file]
  	inRollCall = false
  	inPublicComment = false
		f = file.open
		rollpara = ""
		@resolutions=""
		@inMotionpara="FUCK"
		@datecount=0
		inMotion = false
		@meeting = Meeting.new
		header =false
		@publiccomment = ""
		f.each_line do |line|
			line=line.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
			line = line.delete "\r\n"
			line = line.delete"\n"
			if header
				@datecount= @datecount+1
				if @datecount == 2
					@meeting.date = line
					header = false
				end
			end
			if line.include? 'CUYAHOGA COUNTY' 
				if line.include? 'MEETING'
					@meeting.name = line
					header = true
				end
			end
			if line.include? 'PLEDGE OF ALLEGIANCE'
				inRollCall = false
			end
			if inRollCall
				rollpara += line.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
			end
			if line.include? 'ROLL CALL'
				inRollCall = true
				@lines = line
			end			
			line.split(' ').each do |word|
				if word.match (/R\d\d\d\d-\d\d\d\d/)
					@resolutions=word[/R\d\d\d\d-\d\d\d\d/]
				end
			end
			if line.include? 'motion'
				inMotion = true
			end
			if line.chomp.empty? && inMotion = true
				inMotion = false
				@event = Motions.new
				@event.meeting = @meeting.name
				@event.date = @meeting.date
				@event.description = @inMotionpara
				if @event.description.empty?
					@event.description="mentioned"
				end
				@event.name = @resolutions
				@event.save
				@inMotionpara=""
			end
			if inMotion
				@inMotionpara+= line + "\n"
			end
			if line.include? 'ADJOURNMENT' 
				if inPublicComment
					if @meeting.publiccomment == nil
						@meeting.publiccomment = ""
					end
					@meeting.publiccomment += @publiccomment.gsub(/No public comments were given./,'')
					inPublicComment = false
				end
			end
			if line.include? 'APPROVAL OF MINUTES' 
				if inPublicComment
					if @meeting.publiccomment == nil
						@meeting.publiccomment = ""
					end
					@meeting.publiccomment += @publiccomment.gsub(/No public comments were given./,'')
					inPublicComment = false
				end
			end

			if inPublicComment
				@publiccomment += line.chomp
			end
			if line.include? 'PUBLIC COMMENT'
				inPublicComment = true
			end



		end	
		rollpara.split('.').each do |x|
			if x.include? 'absent'
				@lines = ""
				x.split(' ').each do |word|
					if word[0] == word[0].capitalize && word != 'Councilmembers' && word != 'Councilmember' && word != 'Committee'
						@lines+= ' '+word
						@absent = Absent.new
						@absent.name = word
						@absent.date = @meeting.date
						@absent.meeting = @meeting.name
						@absent.save
					end
				end
			end
		end
		@lines=@lines.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
		f.close
		@meeting.save
	end
	def meetings
		@committee = params[:name]
		@jsonmeetingarray = Array.new
		@meetings = Meeting.select(:name,:date,:publiccomment).distinct.where(name: @committee)
		@meetings.each do |meeting|			
			@absents = Absent.select(:name).distinct.where(meeting: meeting.name,date:meeting.date)
			@date = meeting.date
			@name=meeting.name.delete "\r\n"
			@name=@name.delete "\u0026"
			@events = Motions.select(:name,:description).distinct.where(meeting: meeting.name, date: meeting.date)
			jsonmeeting = Jsonmeeting.new(@name,@date,@absents, @events, meeting.publiccomment)
			@absents = jsonmeeting.absentMembers
			@events = jsonmeeting.events
			@json = jsonmeeting.to_json
			@jsonmeetingarray.push(@json)
			@jsonmeetinglist = Jsonmeetinglist.new(@committee, @jsonmeetingarray, "BLAH")
			@json = @jsonmeetinglist.to_json
		end
	end
end
