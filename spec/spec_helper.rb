# $LOAD_PATH << File.expand_path('../lib', __FILE__)
require "pry"
require "log2blog"
require "factory_girl"

FactoryGirl.find_definitions

RSpec::Matchers.define :be_sorted do
  match do |actual|
    actual == actual.sort
  end
end
