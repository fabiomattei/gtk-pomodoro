module Pomodoro

  class Application < Gtk::Application

    def initialize
      super 'net.funambolo.gtk-pomodoro', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        window = Gtk::ApplicationWindow.new(application)
        window.set_title 'GTK Pomodoro'
        window.present
      end
    end

  end

end
