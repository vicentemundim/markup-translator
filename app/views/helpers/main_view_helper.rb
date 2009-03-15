class MainViewHelper < ApplicationViewHelper
  observable_property :opened_files, :initial_value => {}

  def post_registration(view)
    @view = view
  end

  def open_file(file_id)
    self.opened_files[file_id] = {:page_number => new_page_id}
  end

  def new_page_id
    @view.files_notebook.n_pages + 1
  end
end
