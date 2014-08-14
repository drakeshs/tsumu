# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

[Database,Cache,Application,EcoSystem].map(&:destroy_all)

stack = YAML::load_file(Rails.root.join("config/stack.yml"))
stack["eco_systems"].each do |eco_system|
  es = EcoSystem.create( eco_system )
  KeyPair.create( eco_system: es )
end
EcoSystem.groups
stack["databases"].each do |db|
  db.delete("eco_systems").each do |es|
    d_eco_system = EcoSystem.where(name:es).first
    Database.create( db.merge({ name: "#{d_eco_system.name}-#{es["name"]}", database_name: "#{d_eco_system.name}-#{es["name"]}", eco_system: d_eco_system  }) )
  end
end
stack["caches"].each do |cache|
  cache.delete("eco_systems").each do |es|
    d_eco_system = EcoSystem.where(name:es).first
    Cache.create( cache.merge({ name: "#{d_eco_system.name}-#{es["name"]}", database_name: "#{d_eco_system.name}-#{es["name"]}", eco_system: d_eco_system  }) )
  end
end
stack["applications"].each do |app|
  app.delete("eco_systems").each do |es|
    record = Application.create(app.merge({ eco_system: EcoSystem.where(name:es).first }) )
    Server.create( application: record, groups_name: record.eco_system.server_groups.map(&:box_id) )
  end
end

# only for integration app in deploy
# MongoServer.create( application: a, groups_name: [ a.eco_system.database_groups.last.box_id] )