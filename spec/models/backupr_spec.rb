require "spec_helper"

describe Backupr do
  describe "#host" do
    it "should be configurable via cool dsl" do
      Backupr.host "test" do |host|
        host.address = "text.example.com"
        host.
      end
    end
  end
end