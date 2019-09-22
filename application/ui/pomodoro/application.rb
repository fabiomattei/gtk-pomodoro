module Pomodoro

  class Application < Gtk::Application
    attr_reader :user_data_path

    def initialize
      super 'net.funambolo.gtk-pomodoro', Gio::ApplicationFlags::FLAGS_NONE

      @user_data_path = File.expand_path('~/.gtk-pomodoro')
      unless File.directory?(@user_data_path)
        puts "First run. Creating user's application path: #{@user_data_path}"
        FileUtils.mkdir_p(@user_data_path)
      end

      signal_connect :activate do |application|
        window = Gtk::ApplicationWindow.new(application)
        window.set_default_size 500, 400
        @stop_timer = false
        window.set_titlebar MyHeaderBar.new self
        window.add MyGrid.new

        window.show_all
      end

    end

  end

end
