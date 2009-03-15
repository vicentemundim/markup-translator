class MainController < RuGUI::BaseMainController
  def setup_controllers
    register_controller :translator_controller
  end

  def setup_views
    register_view :main_view
  end

  def quit_application(widget = nil, event = nil)
    quit
  end
end
