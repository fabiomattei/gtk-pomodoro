module Pomodoro

  class Application < Gtk::Application

    def initialize
      super 'net.funambolo.gtk-pomodoro', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        window = Gtk::ApplicationWindow.new(application)
        window.set_title 'GTK Pomodoro'
        window.set_default_size 500, 400
        
        window.set_titlebar init_header_bar
        window.add init_ui

        window.show_all
      end
    end

    def init_header_bar
      header_bar = Gtk::HeaderBar.new
      quit_button = Gtk::Button.new :label => "Quit"
      quit_button.signal_connect "clicked" do 
          quit
      end
      header_bar.add quit_button
      return header_bar
    end 

    def init_ui
      #initializing grid layout
      grid = Gtk::Grid.new

      entry = Gtk::Entry.new
      entry.set_width_chars 100
      start_button = Gtk::Button.new :label => "Start"
      project_selector = Gtk::ComboBoxText.new
      counter = Gtk::Label.new '25:00'

      project_selector.append_text 'Project 1'
      project_selector.append_text 'Project 2'

      list_store = Gtk::ListStore.new(String, String, String)
      iter = list_store.append
      iter[0] = "My first task"
      iter[1] = "Pomodoro GTK"
      iter[2] = "25:00"

      work_done = Gtk::TreeView.new(list_store)
      renderer = Gtk::CellRendererText.new

      column = Gtk::TreeViewColumn.new("Task", renderer, :text => 0)
      column.resizable = true
      work_done.append_column(column)

      column = Gtk::TreeViewColumn.new("Project", renderer, :text => 1)
      column.resizable = true
      work_done.append_column(column)

      column = Gtk::TreeViewColumn.new("Time", renderer, :text => 2)
      column.resizable = true
      work_done.append_column(column)
      
      grid.attach entry, 0, 0, 1, 1
      grid.attach project_selector, 1, 0, 1, 1
      grid.attach start_button, 2, 0, 1, 1
      grid.attach counter, 0, 1, 3, 1
      grid.attach work_done, 0, 2, 3, 1

      # adding grid layout to current window 
      return grid
    end

  end

end
