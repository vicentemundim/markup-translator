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
    self.translator_controller.new_translator
  end

  def quit_application(widget = nil, event = nil)
    quit
  end
end
