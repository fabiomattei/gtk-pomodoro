module Pomodoro
  
  class MyHeaderBar < Gtk::HeaderBar

    def initialize(application)
      super()

      # set title for HeaderBar, when I set a HeaderBar the window title desappears
      set_title 'GTK Pomodoro'

      # shows all buttons for windows resizing and for shutting down the application
      # and not only the close button
      set_show_close_button true

      # Adding log
      log_button = Gtk::Button.new :icon_name => "preferences-system"
      add log_button

      # Adding settings
      settings_button = Gtk::Button.new :icon_name => "edit-find"
      add settings_button

    end

  end

end