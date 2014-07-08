package "patchutils"

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"


rbenv_ruby "2.1.1" do
  global true
  patch "https://bugs.ruby-lang.org/projects/ruby-trunk/repository/revisions/45225/diff?format=diff"
end

rbenv_gem "bundler" do
  ruby_version "2.1.1"
end