# $LOAD_PATH << File.expand_path('../lib', __FILE__)
require "pry"
require "log2blog"
require "factory_girl"

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

def sorted?( array )
  array == array.sort
end

def sorted_in_reverse?( array )
  array == array.sort.reverse
end
