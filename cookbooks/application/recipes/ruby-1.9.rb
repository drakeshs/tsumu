package "patchutils"

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"


rbenv_ruby "1.9.3-p327" do
  global true
end

rbenv_gem "bundler" do
  ruby_version "1.9.3-p327"
end