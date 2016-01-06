# $LOAD_PATH << File.expand_path('../lib', __FILE__)
require "pry"
require "log2blog"
require "factory_girl"

FactoryGirl.find_definitions

RSpec::Matchers.define :contain_in_order do |elements|
  match do |container|
    positions = elements.map { |element| subject.index element }
    positions == positions.sort
  end
end
