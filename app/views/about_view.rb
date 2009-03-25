class AboutView < ApplicationView
  use_builder

  on :about_dialog, 'response' do |widget, event|
    widget.hide
  end
end
