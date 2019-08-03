module Pomodoro

  class Application < Gtk::Application

    def initialize
      super 'net.funambolo.gtk-pomodoro', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        window = Gtk::ApplicationWindow.new(application)
        window.set_title 'GTK Pomodoro'
        window.set_default_size 500, 400

        window.add init_ui

        window.show_all
      end
    end

    def init_ui
      #initializing grid layout
      grid = Gtk::Grid.new

      entry = Gtk::Entry.new
      entry.set_width_chars 100
      start_button = Gtk::Button.new :label => "Start"
      project_selector = Gtk::ComboBoxText.new

      project_selector.append_text 'Project 1'
      project_selector.append_text 'Project 2'
      
      grid.attach entry, 0, 0, 1, 1
      grid.attach project_selector, 1, 0, 1, 1
      grid.attach start_button, 2, 0, 1, 1

      # adding grid layout to current window 
      return grid
    end

  end

end
