#
# Author:: 
# Resource:: 
#

actions         :deploy
default_action  :deploy

attribute :name             , :kind_of => String, :name_attribute => true
attribute :source           , :kind_of => String
attribute :metrics          , :kind_of => Hash
attribute :collect_time     , :kind_of => Integer
attribute :threshold_time   , :kind_of => Integer

def initialize(*args)
  super
  @action = :deploy
end 
