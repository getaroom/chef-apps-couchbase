require "bundler/setup"

task :default => :foodcritic

task :foodcritic do
  sh %{foodcritic . --epic-fail ~solo --epic-fail ~FC023}
end
