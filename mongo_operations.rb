require 'mongo'

class MongoOperations

  def self.create_client
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'local')
    return client
  end

  def self.create_mongo_db(client, db_name)
    new_db = Mongo::Database.new(client, :"#{db_name}")
    client.close
    return new_db
  end

  def self.create_mongo_collection(db, collection_name)
    new_collection = Mongo::Collection.new(db, "#{collection_name}")
    return new_collection
  end

  def self.insert_to_collection(collection, word, count)
    doc = {word: word, count: count}
    res= collection.insert_one(doc)
  end

  def self.delete_collection_direct(collection)
    collection.drop
  end

  def self.delete_db(db)
    db.drop
  end
end