require 'spec_helper'
require 'tmpdir'
require 'backupr/cleaner'

INITIAL_DIRS = 912 # must be >= 912

describe Backupr::Cleaner do
  # describe "last_group" do
  #   it "groups by block and returns last group" do
  #     (last_group (0...10).to_a { |i| i % 2 }).must_equal([1, 3, 5, 7, 9])
  #     (last_group (0...10).to_a { |i| i % 3 }).must_equal([2, 5, 8])
  #     (last_group (0...10).to_a { |i| i % 4 }).must_equal([3, 7])
  #     (last_group (0...10).to_a { |i| i % 5 }).must_equal([4, 9])
  #     (last_group (0...10).to_a { |i| i % 6 }).must_equal([5])
  #   end
  # end

  # describe "clean" do
  #   before do
  #     TESTDIR = Dir.mktmpdir
  #
  #     Dir.chdir TESTDIR
  #     now = Time.now.utc
  #     now = Time.new(now.year, now.month, now.day, now.hour, 0, 0, 0).utc
  #
  #     0.upto(INITIAL_DIRS - 1) do |i|
  #       FileUtils.mkpath (now - i * 3600).strftime(Backupr::DirFormat)
  #     end
  #   end
  #
  #   after do
  #     FileUtils.rmtree TESTDIR
  #   end
  #
  #   it "should clean" do
  #     Dir.chdir TESTDIR
  #     Dir["*"].count.must_equal INITIAL_DIRS
  #     Backupr::Cleaner.new(TESTDIR).clean
  #     Dir["*"].count.must_equal 24 + 31 + (INITIAL_DIRS / 24 - 31) / 7
  #   end
  # end
end
