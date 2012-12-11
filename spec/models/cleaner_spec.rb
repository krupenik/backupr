require "tmpdir"

TESTDIR = Dir.mktmpdir
INITIAL_DIRS = 4000

describe Backupr::Cleaner do
  describe "clean" do
    before do
      Dir.chdir TESTDIR
      now = Time.now.utc
      now = Time.new(now.year, now.month, now.day, now.hour, 0, 0, 0).utc

      0.upto(INITIAL_DIRS - 1) do |i|
        FileUtils.mkpath (now - i * 3600).strftime(Backupr::DirFormat)
      end
    end

    it "should clean" do
      Dir.chdir TESTDIR
      Dir["*"].count.must_equal INITIAL_DIRS
      Backupr::Cleaner.clean(TESTDIR)
      Dir["*"].count.must_equal 24 + 31 + (INITIAL_DIRS / 24 - 31) / 7 + 1
    end
  end
end
