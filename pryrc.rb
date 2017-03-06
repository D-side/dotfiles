# Pry
# An advanced Ruby REPL.
# Recommended gems for your Gemfile:
# * pry-coolline -- provides syntax highlighting for input string.
# * pry-byebug -- integrates a Ruby 2.0+ debugger.
# * pry-doc -- provides documentation and source code for Ruby standard library.
#              Even provides C code for methods implemented natively. Most of them.
# * colorize -- several clean methods for coloring strings in the terminal
# * awesome_print -- prints objects in a human-readable (more or less) format

# Augments return value inspection by adding scrolling for long output
# (via `less` under Linux) and beautiful formatting using awesome_print (.ai)
require 'awesome_print'
Pry.config.print = proc do |output, value|
  Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai(raw: true)}", output)
end

# A clean prompt with 3-symbol right-padded line numbers and nesting indication
require 'colorize'
Pry.prompt = [
  proc do |obj, nest_level, pry|
    [
      "[#{format '%3d', pry.input_array.size}]".light_blue,
      ("<#{nest_level}>".cyan if nest_level > 0),
      " > ".green
    ].join
  end
]

# For ease of debugging, hitting Enter will repeat the last entered command
# This is so you don't type `next` and `step` all the time, even a single
# character matters.
Pry::Commands.command /^$/, "repeat last command" do
  _pry_.input = StringIO.new(Pry.history.to_a.last)
end

module Multitool
  def in_all_encodings(string)
    Encoding.list.map { |e| [e, (string.dup.force_encoding(e).encode(Encoding.default_external) rescue nil)] }.to_h
  end
end
