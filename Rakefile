#!/usr/bin/env rake

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new "spec" do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
end

Rake::TestTask.new "spec:unit" do |t|
  t.libs << "spec"
  t.pattern = "spec/unit/*_spec.rb"
end

task :default => "spec"
