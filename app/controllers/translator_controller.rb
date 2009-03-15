class TranslatorController < ApplicationController
  def setup_models
    register_model main_controller.manager
  end

  def new_translator
    file_id = main_controller.manager.new_file
    new_translator_view(file_id)
    main_controller.main_view.add_new_file_page(file_id, view_for_file(file_id).root_widget)
  end

  def new_translator_view(file_id)
    register_view :translator_view, file_id
    view = view_for_file(file_id)
    view.textview.buffer.signal_connect('insert-text') do |textbuffer, iter, text, length|
      self.manager.save_temp_markup_file(file_id, textbuffer.text)
      display_browser_preview(file_id)
    end
  end

  def view_for_file(file_id)
    self.views[file_id.to_sym]
  end

  def display_browser_preview(file_id)
    uri = self.manager.markup_translator_file(file_id).temp_markup_file_uri
    view_for_file(file_id).display_browser_preview(uri)
  end
end
