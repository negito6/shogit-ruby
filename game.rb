require 'irb'
require 'irb/completion'
require './lib/shogit'

console = IRB
console::ExtendCommandBundle.include(Shogit::Console)
console.start
