#
# Author:: 
# Resource:: 
#

actions         :deploy
default_action  :deploy

attribute :name         , :kind_of => [String], :name_attribute => true
attribute :source_lib   , :kind_of => [String]
attribute :source_conf  , :kind_of => [String]

def initialize(*args)
  super
  @action = :deploy
end 
