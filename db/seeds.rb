# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
stack = YAML::load_file(Rails.root.join("config/stack.yml"))
stack["eco_systems"].each do |eco_system|
  es = EcoSystem.create( eco_system )
  KeyPair.create( eco_system: es )
end
stack["databases"].each do |db|
  db.delete("eco_systems").each do |es|
    Database.create( db.merge({ eco_system: es }) )
  end
end
stack["caches"].each do |cache|
  cache.delete("eco_systems").each do |es|
    Cache.create( cache.merge({ eco_system: es }) )
  end
end
stack["applications"].each do |app|
  app.delete("eco_systems").each do |es|
    record = Application.create(app.merge({ eco_system: es }) )
    Server.create( application: record )
  end
end