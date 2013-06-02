require File.expand_path('../lib/backupr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dennis Krupenik"]
  gem.email         = ["dennis@krupenik.com"]
  gem.description   = %q{Backup management application}
  gem.summary       = %q{Backupr is a backup management application}
  gem.homepage      = "https://github.com/krupenik/backupr"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "backupr"
  gem.require_paths = ["lib"]
  gem.version       = Backupr::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  # gem.add_development_dependency 'minitest-focus'
end
