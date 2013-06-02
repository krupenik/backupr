require 'tmpdir'
require 'spec_helper'
require 'backupr'

describe Backupr do
  subject { Backupr }
  let(:dir) { Dir.tmpdir }

  before do
    subject.clear
  end

  it "should be configurable via cool dsl" do
    subject.hosts.must_be_empty
    
    subject.configure do |config|
      config.root = dir
    end

    subject.host "test1" do |h|
      h.storage = { paths: %w[/var/vault], filters: ["- *.log"] }
      h.sqldump = { type: "mysql", user: "root", password: "test1", databases: %w[test1 test2] }
    end

    subject.host "test2" do |h|
      h.storage = { paths: %w[/var/vault], filters: ["- *.log"] }
      h.sqldump = { type: "pgsql", password: "test2", databases: :all }
    end

    subject.config.root.must_equal dir
    subject.hosts.keys.must_equal ["test1", "test2"]
    subject.hosts.values.map { |i| i.is_a? Backupr::Host }.all?.must_equal true
  end
end
