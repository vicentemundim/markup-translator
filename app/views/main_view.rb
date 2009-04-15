class MainView < ApplicationView
  use_builder

  def add_file_page(file, translator_root_widget, options = {})
    self.helper.open_file(file.file_id)

    label = options[:new] ? new_page_label : file.filename
    add_page(translator_root_widget, label)
    focus_page(file.file_id)
  end

  def add_page(page_widget, label)
    self.files_notebook.append_page(page_widget, Gtk::Label.new(label))
  end

  def focus_page(file_id)
    self.files_notebook.page = self.helper.page_index_for(file_id)
  end

  def close_file_page(file_id)
    page_index = self.helper.page_index_for(file_id)
    self.helper.close_file(file_id)
    self.files_notebook.remove_page(page_index)
  end

  def new_page_label
    "Unsaved-#{self.helper.new_page_number}"
  end

  def current_file_id
    current_index = self.files_notebook.page
    self.helper.file_id_for(current_index) unless current_index.blank?
  end

  def contents_updated_file_label_for(file)
    page_index = self.helper.page_index_for(file.file_id)
    label = file.filename

    if file.unsaved_changes?
      label << "*" unless label.end_with?("*")
    else
      label.chop if label.end_with?("*")
    end

    child = self.files_notebook.get_nth_page(page_index)
    self.files_notebook.set_tab_label_text(child, label)
  end

  def update_file_id(old_file_id, new_file_id)
    self.helper.update_file_id(old_file_id, new_file_id)
  end

  def prompt_for_open_filesystem_path
    dialog = Gtk::FileChooserDialog.new("Save File",
                                     self.main_window,
                                     Gtk::FileChooser::ACTION_OPEN,
                                     nil,
                                     [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
                                     [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])

    dialog.add_filter(build_filter("Markup", '*.textile'))
    dialog.add_filter(build_filter("All", '*'))
    filename = dialog.filename if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
    dialog.destroy
    filename
  end

  def prompt_for_save_filesystem_path(current_path)
    dialog = Gtk::FileChooserDialog.new("Save File",
                                     self.main_window,
                                     Gtk::FileChooser::ACTION_SAVE,
                                     nil,
                                     [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
                                     [Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_ACCEPT])

    dialog.add_filter(build_filter("Markup", '*.textile'))
    dialog.add_filter(build_filter("All", '*'))
    filename = dialog.filename if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
    dialog.destroy
    filename
  end

  def prompt_for_save_changes(file_id)
    message_box = Gtk::MessageDialog.new(self.main_window,
                                Gtk::Dialog::MODAL,
                                Gtk::MessageDialog::QUESTION,
                                Gtk::MessageDialog::BUTTONS_NONE)
    message_box.markup = "<b>Save changes to #{file_id}?</b>"
    message_box.secondary_markup = "You have unsaved changes in your documents, choose whether to save it."
    message_box.add_buttons([Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL], [Gtk::Stock::NO, Gtk::Dialog::RESPONSE_NO], [Gtk::Stock::YES, Gtk::Dialog::RESPONSE_YES])
    response = message_box.run
    message_box.destroy
    response
  end

  def prompt_for_override_opened_file
    message_box = Gtk::MessageDialog.new(self.main_window,
                                Gtk::Dialog::MODAL,
                                Gtk::MessageDialog::QUESTION,
                                Gtk::MessageDialog::BUTTONS_NONE)
    message_box.markup = "<b>Override opened file?</b>"
    message_box.secondary_markup = "This will close the other file and override it with the new one, are you sure?"
    message_box.add_buttons([Gtk::Stock::NO, Gtk::Dialog::RESPONSE_NO], [Gtk::Stock::YES, Gtk::Dialog::RESPONSE_YES])
    response = message_box.run
    message_box.destroy
    response
  end

  def build_filter(name, patterns)
    filter = Gtk::FileFilter.new
    filter.name = name
    patterns.each { |pattern| filter.add_pattern(pattern) }
    filter
  end
end
