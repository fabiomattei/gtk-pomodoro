module Pomodoro
  
  class ItemList

  	def initialize( filename )
  		@filename = filename
  	end

	# It load items from its `filename` location
  	def load_items_list

  		file = File.open @filename
		data = JSON.load file
		file.close

    end

    # It saves items to its `filename` location
    def save!
      File.open(@filename, 'w') do |file|
        file.write self.to_json
      end
    end

  end

end