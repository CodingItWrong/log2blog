# $LOAD_PATH << File.expand_path('../lib', __FILE__)
require "pry"
require "log2blog"

def sorted?( array )
  array == array.sort
end

def sorted_in_reverse?( array )
  array == array.sort.reverse
end
