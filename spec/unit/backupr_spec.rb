require 'spec_helper'
require 'backupr'

class HostStub
  def address; "test1"; end
  def is_a? whatever; true; end
  def valid?; true; end
end

describe Backupr do
  describe "add_host" do
    subject { Backupr }

    before do
      subject.clear
    end

    it "should add hosts" do
      host = HostStub.new

      subject.add_host host
      subject.hosts.must_equal Hash["test1", host]
    end

    it "should not accept the same host twice" do
      host = HostStub.new

      subject.add_host host
      -> { subject.add_host host }.must_raise Backupr::DuplicateEntryError
    end
  end
end
