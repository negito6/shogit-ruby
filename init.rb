require './lib/shogit'

git = Shogit::Git.new
Shogit::File.new.touch
git.add_and_commit(Shogit::File.new, "init")
