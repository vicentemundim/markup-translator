class MarkupTranslatorFile < RuGUI::BaseModel
  observable_property :file_id, :prevent_reset => true
  observable_property :contents, :prevent_reset => true
  observable_property :markup_type, :initial_value => 'textile', :prevent_reset => true
  observable_property :filesystem_path, :prevent_reset => true
  observable_property :unsaved_changes, :boolean => true, :initial_value => false
  observable_property :is_new, :boolean => true, :initial_value => false

  def save
    self.reset!

    save_to_filesystem
  end

  def changed!
    self.unsaved_changes = true
  end

  def save_temp_markup_file(contents)
    if self.contents != contents
      self.changed!
      self.contents = contents
    end
    
    save_as_file(temp_markup_file_path, self.markup_contents)
  end

  def temp_markup_file_path
    File.expand_path(File.join(RuGUI.root, 'app', 'resources', 'temp', temp_markup_file_name))
  end

  def temp_markup_file_uri
    "file://#{temp_markup_file_path}"
  end

  def temp_markup_file_name
    if self.is_new?
      self.file_id.end_with?(self.markup_type) ? self.file_id : "#{self.file_id}.#{self.markup_type}"
    else
      File.basename(self.filesystem_path)
    end
  end

  def markup_contents
    respond_to?(markup_contents_method) ? send(markup_contents_method) : self.contents
  end

  def textile_contents
    RedCloth.new(self.contents).to_html
  end

  private
    def save_to_filesystem
      save_as_file(self.filesystem_path, self.contents)
    end

    def save_as_file(path, contents)
      File.open(path, 'w') do |file|
        file.write contents
      end unless path.nil?
    end

    def markup_contents_method
      "#{self.markup_type || 'textile'}_contents"
    end
end
