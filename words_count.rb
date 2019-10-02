require 'concurrent'
require 'mongo'
require_relative 'mongo_operations'

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


#words_counter = WordsCount.new('/Users/tomerbendavid/RubymineProjects/learning_ruby/rubyTestFolder')
#res = MongoOperations.delete_collection(collection_name)
#MongoOperations.delete_db(new_db)
words_counter = WordsCount.new(ARGV[0])

db_name = 'words'
collection_name = "words_count"

words_counter.get_files_from_dir
new_db = MongoOperations.create_mongo_db('words')
new_collection = MongoOperations.create_mongo_collection(new_db, collection_name)
words_counter.words_hash.each do|word, count|
  MongoOperations.insert_to_collection(db_name, collection_name, word, count)
  puts "#{word} : #{count}"
end



