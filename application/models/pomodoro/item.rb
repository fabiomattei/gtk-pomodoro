require 'securerandom'
require 'json'

module Pomodoro
  
  class Item

    attr_accessor :text, :project, :time, :date

    def initialize(text, project, time, date)
      @text = text
      @project = project
      @time = time
      @date = date
    end

  end

end