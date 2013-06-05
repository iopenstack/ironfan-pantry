#
# Author:: 
# Resource:: 
#

actions         :deploy
default_action  :deploy

attribute :name     , :kind_of => String, :name_attribute => true
attribute :source   , :kind_of => String
attribute :metrics  , :kind_of => Array

def initialize(*args)
  super
  @action = :deploy
end 
