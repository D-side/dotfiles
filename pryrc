# Fancy object inspection
require 'awesome_print'

# Paging and awesome_print
Pry.config.print = proc do |output, value|
  Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai(raw: true)}", output)
end

# Colorful prompt
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

# Hitting Enter without a command will repeat last command: `next` in byebug?
Pry::Commands.command /^$/, "repeat last command" do
  _pry_.input = StringIO.new(Pry.history.to_a.last)
end
