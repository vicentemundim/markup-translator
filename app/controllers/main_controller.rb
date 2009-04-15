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

  on :action_new, 'activate' do
    self.translator_controller.new_translator
  end

  on :action_open, 'activate' do
    self.translator_controller.open
  end

  on :action_save, 'activate' do
    self.translator_controller.save
  end

  on :action_save_as, 'activate' do
    self.translator_controller.save_as
  end

  on :action_close, 'activate' do
    self.translator_controller.close
  end

  on :action_about, 'activate' do
    self.about_view.about_dialog.show
  end

  on :action_quit, 'activate' do
    quit
  end

  on :main_window, 'delete-event' do
    quit
  end
end
