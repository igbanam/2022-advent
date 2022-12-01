module Helpers
  def get_data_file(file)
    File.basename(file, '.rb') + '.in'
  end
end
