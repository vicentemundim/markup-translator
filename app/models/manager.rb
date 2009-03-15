class Manager < RuGUI::BaseModel
  observable_property :opened_files, :initial_value => {}

  attr_accessor :last_new_page_id

  def new_file_id
    self.last_new_page_id = (self.last_new_page_id || 0) + 1
    "new_file_#{self.last_new_page_id}"
  end

  def new_file
    file_id = new_file_id
    self.opened_files[new_file_id] = TranslatorFile.new
    file_id
  end
end
