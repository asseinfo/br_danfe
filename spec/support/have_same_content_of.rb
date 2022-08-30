# :nocov:
RSpec::Matchers.define(:have_same_content_of) do |file: nil|
  expected_file_path = file

  match do |actual_file_path|
    if File.exist?(actual_file_path)
      expect(md5_hash(actual_file_path)).to eq(md5_hash(expected_file_path))
    else
      create_when_missing(expected_file_path, actual_file_path)
    end
  end

  def md5_hash(file_path)
    Digest::MD5.hexdigest(File.read(file_path))
  end

  def create_when_missing(expected_file_path, actual_file_path)
    puts '+----------------------------------------------------'
    puts '|'
    puts "| The file bellow doesn't exists and will be created:"
    puts '|'
    puts "| #{actual_file_path}"
    puts '|'
    puts '+----------------------------------------------------'

    FileUtils.cp(expected_file_path, actual_file_path)

    false
  end
end
# :nocov:
