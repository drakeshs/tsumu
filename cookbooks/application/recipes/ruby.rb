package "patchutils"

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"


rbenv_ruby "2.1.1" do
  global true
end

rbenv_ruby "1.9.3-p547" do
  global true
end

rbenv_gem "bundler" do
  ruby_version "2.1.1"
end

rbenv_gem "bundler" do
  ruby_version "1.9.3-p547"
end