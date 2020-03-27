module Pomodoro
  
  class ItemList

  	attr_reader :data

  	def initialize( filename )
  		@filename = filename
  		load_items_list
  	end

	  # It loads items from its `filename` location
  	def load_items_list
  		file = File.open File.expand_path @filename
		  @data = JSON.load file
      file.close
    end

    # It saves items to its `filename` location
    def save! json_string
      File.open( File.expand_path( @filename ), 'w') do |file|
        file.write json_string
      end
    end

  end

end