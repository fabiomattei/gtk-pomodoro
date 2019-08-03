module Pomodoro

  class Application < Gtk::Application

    def initialize
      super 'net.funambolo.gtk-pomodoro', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        window = Gtk::ApplicationWindow.new(application)
        window.set_title 'GTK Pomodoro'
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

      # Adding quit button
      quit_button = Gtk::Button.new :label => "Quit"
      quit_button.signal_connect "clicked" do 
          application.quit
      end
      add quit_button

      # Adding log
      log_button = Gtk::Button.new :label => "Activities Log"
      add log_button

      # Adding settings
      settings_button = Gtk::Button.new :label => "Settings"
      add settings_button

    end

  end

  class MyGrid < Gtk::Grid

    def initialize
      super()

      entry = Gtk::Entry.new
      entry.set_width_chars 100
      start_button = Gtk::Button.new :label => "Start"
      start_button.signal_connect "clicked" do 
        start_timer
      end

      pause_button = Gtk::Button.new :label => "Pause"
      pause_button.signal_connect "clicked" do 
        @pause = false
      end

      project_selector = Gtk::ComboBoxText.new
      @counter = Gtk::Label.new '25:00'

      project_selector.append_text 'Project 1'
      project_selector.append_text 'Project 2'

      list_store = Gtk::ListStore.new(String, String, String)
      iter = list_store.append
      iter[0] = "My first task"
      iter[1] = "Pomodoro GTK"
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
      attach pause_button, 3, 0, 1, 1
      attach @counter, 0, 1, 4, 1
      attach work_done, 0, 2, 4, 1
    end

    def start_timer
      @total_seconds = 25 * 60
      puts(@total_seconds.to_s)
      @timeout_id = GLib::Timeout.add_seconds(1) { update_counter }
    end

    def update_counter
      #puts(@total_seconds.to_s)
      if @total_seconds > 0
        @total_seconds = @total_seconds - 1
        minutes = 24 - (25 * 60 - @total_seconds) / 60
        seconds = 59 - (25 * 60 - @total_seconds) % 60
        @counter.set_label '%02d:%02d' % [minutes, seconds] 
        @timeout_id = GLib::Timeout.add(1000000) { update_counter }
        return true
      else
        #puts("done")
        return false
      end
    end

  end

end
