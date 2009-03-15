class AboutView < ApplicationView
  use_glade

  def on_about_dialog_response(widget, event)
    self.about_dialog.hide
  end
end
