require 'gtkmozembed'

class TranslatorView < ApplicationView
  root :translator_hpaned
  use_builder

  def setup_widgets
    build_widget(Gtk::MozEmbed, :browser, :browser_vbox)
  end

  def display_browser_preview(uri)
    self.browser.location = uri
  end
end
