class Manager < RuGUI::BaseModel
  observable_property :opened_files, :initial_value => {}

  attr_accessor :last_new_page_id

  def new_file_id
    self.last_new_page_id = (self.last_new_page_id || 0) + 1
    "new_file_#{self.last_new_page_id}"
  end

  def update_opened_file_id(old_file_id, filesystem_path)
    new_file_id = cleaned_file_id(filesystem_path)
    self.opened_files[old_file_id].file_id = new_file_id
    self.opened_files[new_file_id] = self.opened_files.delete(old_file_id)
    new_file_id
  end

  def new_file
    file_id = new_file_id
    self.opened_files[file_id] = MarkupTranslatorFile.new(:file_id => file_id, :is_new => true)
  end

  def open_file(filesystem_path)
    unless filesystem_path.blank? or not File.file?(filesystem_path)
      file_id = cleaned_file_id(filesystem_path)
      file = MarkupTranslatorFile.new(
        :file_id => file_id,
        :filesystem_path => filesystem_path,
        :contents => File.read(filesystem_path)
      )

      self.opened_files[file_id] = file
    end
  end

  def close_file(file_id)
    self.opened_files.delete(file_id)
  end

  def save_temp_markup_file(file_id, contents)
    markup_translator_file(file_id).save_temp_markup_file(contents)
  end

  def markup_translator_file(file_id)
    self.opened_files[cleaned_file_id(file_id)]
  end

  def has_opened_file?(file_id)
    self.opened_files.has_key?(cleaned_file_id(file_id))
  end

  def has_opened_files?
    not self.opened_files.blank?
  end

  def cleaned_file_id(file_id)
    File.basename(file_id).gsub(/[\W]/, '_') unless file_id.nil?
  end
end
