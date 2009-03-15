class TranslatorController < ApplicationController
  def new_translator_view(view_name)
    register_view :translator_view, view_name
    self.views[view_name.to_sym].root_widget
  end
end
