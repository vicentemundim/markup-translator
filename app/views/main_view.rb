class MainView < ApplicationView
  use_builder

  def add_new_file_page(file_id, translator_root_widget)
    self.helper.open_file(file_id)
    self.files_notebook.append_page(translator_root_widget, build_page_label(new_page_label))
  end

  def build_page_label(label)
    build_widget(Gtk::Label, nil, nil, label)
  end

  def new_page_label
    "Unsaved-#{self.helper.new_page_id}"
  end
end
