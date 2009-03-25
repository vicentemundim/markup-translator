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

  on :about_menuitem, 'activate' do |widget|
    self.about_view.about_dialog.show
  end

  on :new_menuitem, 'activate' do |widget|
    self.translator_controller.new_translator
  end

  on :main_window, 'delete-event', :quit_application
  on :quit_menu_item, 'activate', :quit_application

  def quit_application(widget = nil, event = nil)
    quit
  end
end
