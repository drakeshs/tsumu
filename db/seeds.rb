# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
["development", "qa", "staging", "production"].each do |env|
  es = EcoSystem.create(name: env, vpc: er, subnet: sg, provider: "aws", keyss...)
  YAML::load_file(Rails.root.join("config/stack.yml"))["applications"].each do |app|
    es.applications << Application.create(name: app["name"], github: app["github"], environment: env)
  end
end