class MainController < RuGUI::BaseMainController
  def setup_models
    register_model :manager
  end

  def setup_controllers
    register_controller :translator_controller
  end

  def setup_views
    register_view :main_view
    register_view :about_view
  end

  def open_about_dialog(widget)
    self.about_view.about_dialog.show
  end

  def new_file(widget)
    file_id = self.manager.new_file
    translator_root_widget = self.translator_controller.new_translator_view(file_id)
    self.main_view.add_new_file_page(file_id, translator_root_widget)
  end

  def quit_application(widget = nil, event = nil)
    quit
  end
end
