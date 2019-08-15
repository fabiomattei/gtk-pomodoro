module Pomodoro

  class Application < Gtk::Application
    attr_reader :user_data_path

    def initialize
      super 'net.funambolo.gtk-pomodoro', Gio::ApplicationFlags::FLAGS_NONE

      #@user_data_path = File.expand_path('~/.gtk-pomodoro')
      #unless File.directory?(@user_data_path)
      #  puts "First run. Creating user's application path: #{@user_data_path}"
      #  FileUtils.mkdir_p(@user_data_path)
      #end

      signal_connect :activate do |application|
        window = Gtk::ApplicationWindow.new(application)
        window.set_default_size 500, 400
        
        window.set_titlebar MyHeaderBar.new self
        window.add MyGrid.new

        window.show_all
      end

    end

  end

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

  class MyGrid < Gtk::Grid

    def initialize
      super()

      @pause = false

      entry = Gtk::Entry.new
      entry.set_width_chars 100
      start_button = Gtk::Button.new :label => "Start"
      start_button.signal_connect "clicked" do 
        start_timer
      end

      @pause_button = Gtk::Button.new :label => "Pause"
      @pause_button.signal_connect "clicked" do 
        pause_button_pushed
      end

      end_button = Gtk::Button.new :label => "End"

      project_selector = Gtk::ComboBoxText.new
      @counter = Gtk::Label.new '25:00'

      project_selector.append_text 'Project 1'
      project_selector.append_text 'Project 2'

      list_store = Gtk::ListStore.new(String, String, String)
      iter = list_store.append 
      iter[0] = "My first task"
      iter[1] = "Pomodoro GTK"
      iter[2] = "25"
      iter = list_store.append 
      iter[0] = "sssss first task"
      iter[1] = "ccc Pomodoro GTK"
      iter[2] = "25"

      work_done = Gtk::TreeView.new(list_store)
      renderer = Gtk::CellRendererText.new

      column = Gtk::TreeViewColumn.new("Task", renderer, :text => 0)
      column.resizable = true
      work_done.append_column(column)

      column = Gtk::TreeViewColumn.new("Project", renderer, :text => 1)
      column.resizable = true
      work_done.append_column(column)

      column = Gtk::TreeViewColumn.new("Time (Min)", renderer, :text => 2)
      column.resizable = true
      work_done.append_column(column)
      
      attach entry, 0, 0, 1, 1
      attach project_selector, 1, 0, 1, 1
      attach start_button, 2, 0, 1, 1
      attach @pause_button, 3, 0, 1, 1
      attach end_button, 4, 0, 1, 1
      attach @counter, 0, 1, 5, 1
      attach work_done, 0, 2, 5, 1
    end

    def pause_button_pushed
      @pause = !@pause
      if @pause
        @pause_button.set_label "Resume"
      else
        @pause_button.set_label "Pause"
        resume_timer
      end
    end

    def start_timer
      @total_seconds = 25 * 60
      @timeout_id = GLib::Timeout.add_seconds(1) { update_counter }
    end

    def resume_timer
      @timeout_id = GLib::Timeout.add_seconds(1) { update_counter }
    end

    def update_counter
      #puts(@total_seconds.to_s)
      if !@pause
        if @total_seconds > 0
          @total_seconds = @total_seconds - 1
          minutes = 24 - (25 * 60 - @total_seconds) / 60
          seconds = 59 - (25 * 60 - @total_seconds) % 60
          @counter.set_label '%02d:%02d' % [minutes, seconds] 
          @timeout_id = GLib::Timeout.add(1000000) { update_counter }
          return true
        else
          return false
        end
      end
      return false
    end

  end

end
