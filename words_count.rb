require 'concurrent'

class WordsCount
  @words_hash
  @dir_path
  attr_reader :words_hash

  def initialize(dir_path)
    @words_hash = Concurrent::Hash.new
    @dir_path = dir_path
  end

  def get_files_from_dir
    Dir::foreach(@dir_path) do |file_name|
      next if file_name == '.' or file_name == '..' or file_name == '.DS_Store'
      file_path = File.join(@dir_path, file_name)
      read_line_by_line(file_path)
    end
    sort_hash
  end

  def read_line_by_line(file_path)
    f = File.open(file_path, "r")
    f.each_line do |line|
      insert_to_hash(line)
    end
  end

  def insert_to_hash(line)
    words = line.encode('UTF-8').split(" ")
    words.each do |w|
      w.downcase!
      if @words_hash.has_key?(w)
        @words_hash[w] += 1
      else
        @words_hash[w] = 1
      end
    end
  end

  def sort_hash
    @words_hash = @words_hash.sort_by{|word, count| count}
  end

end

words_counter = WordsCount.new(ARGV[0])
words_counter.get_files_from_dir
words_counter.words_hash.each do |word, count|
  puts "#{word} : #{count}"
end
