module Pomodoro

  class MyGrid < Gtk::Grid

    def initialize
      super()

      @pause = false
      @stop_timer = false
      @filename = '~/.gtk-pomodoro/gtk-pomodoro-data.json'

      @entry = Gtk::Entry.new
      @entry.set_width_chars 100
      start_button = Gtk::Button.new :label => "Start"
      start_button.signal_connect "clicked" do 
        start_timer
      end

      @pause_button = Gtk::Button.new :label => "Pause"
      @pause_button.signal_connect "clicked" do 
        pause_button_pushed
      end

      end_button = Gtk::Button.new :label => "End"
      end_button.signal_connect "clicked" do 
        end_button_pushed
      end

      @project_selector = Gtk::ComboBoxText.new
      @counter = Gtk::Label.new '25:00'

      @project_selector.append_text 'Project 1'
      @project_selector.append_text 'Project 2'

      @list_store = Gtk::ListStore.new(String, String, String, String)
      #iter = @list_store.append 
      #iter[0] = "My first task"
      #iter[1] = "Pomodoro GTK"
      #iter[2] = "25"
      #iter = @list_store.append 
      #iter[0] = "sssss first task"
      #iter[1] = "ccc Pomodoro GTK"
      #iter[2] = "25"

      work_done = Gtk::TreeView.new(@list_store)
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

      column = Gtk::TreeViewColumn.new("Date", renderer, :text => 3)
      column.resizable = true
      work_done.append_column(column)
      
      attach @entry, 0, 0, 1, 1
      attach @project_selector, 1, 0, 1, 1
      attach start_button, 2, 0, 1, 1
      attach @pause_button, 3, 0, 1, 1
      attach end_button, 4, 0, 1, 1
      attach @counter, 0, 1, 5, 1
      attach work_done, 0, 2, 5, 1

      load_data
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

    def end_button_pushed
      task_done
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
      if !@stop_timer
        if !@pause
          if @total_seconds > 0
            @total_seconds = @total_seconds - 1
            minutes = 24 - (25 * 60 - @total_seconds) / 60
            seconds = 59 - (25 * 60 - @total_seconds) % 60
            @counter.set_label '%02d:%02d' % [minutes, seconds] 
            @timeout_id = GLib::Timeout.add(1000000) { update_counter }
            return true
          else
            task_done
            return false
          end
        end
      else 
        @stop_timer = false
      end
      return false
    end

    def task_done
      iter = @list_store.append
      iter[0] = @entry.text
      iter[1] = @project_selector.active_text
      iter[2] = @counter.text
      iter[3] = Time.now.strftime("%d/%m/%Y")

      @counter.text= "25:00"
      @entry.text= ""
      @stop_timer = true

      save_data
            
    end

    def load_data
      items_list = ItemList.new @filename

      items = items_list.data.map { |it| Item.new(it['text'], it['project'], it['time'], it['date']) }

      items.each do |item|
        iter = @list_store.append 
        iter[0] = item.text
        iter[1] = item.project
        iter[2] = item.time
        iter[3] = item.date
      end

    end

    def save_data
      data_to_store = Array.new

      @list_store.each do |_model, path, iter|
        item_to_store = Hash.new
        item_to_store[:text] = iter[0] || ''
        item_to_store[:project] = iter[1] || ''
        item_to_store[:time] = iter[2]
        item_to_store[:date] = iter[3] || ''
        data_to_store << item_to_store
      end

      items_list = ItemList.new @filename

      items_list.save! data_to_store.to_json
    end

  end

end
