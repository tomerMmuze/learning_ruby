require 'mongo'


#should i pass client as a variable between all methods or create a new one every time
class MongoOperations

  def self.create_client
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'local')
    return client
  end

  def self.create_mongo_db(db_name)
    client = create_client
    new_db = Mongo::Database.new(client, :"#{db_name}")
    client.close
    return new_db
  end

  def self.create_mongo_collection(db, collection_name)
    new_collection = Mongo::Collection.new(db, "#{collection_name}")
    return new_collection
  end

  def self.insert_to_collection(db_name, collection_name, word, count)
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => "#{db_name}")

    client.collections.each { |coll| puts coll.name }

    current_collection = client[:"#{collection_name}"]
    doc = {word: word, count: count}
    res = current_collection.insert_one(doc)
    current_collection.find.each{|food| puts food}
  end

  def self.delete_collection(collection_name)
    client = create_client
    res = client[:"#{collection_name}"].drop()
    return res
  end

  def self.delete_db(db)
    db.drop
  end
end