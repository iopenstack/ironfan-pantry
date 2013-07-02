#
# Author:: 
# Resource:: 
#

actions         :deploy
default_action  :deploy

attribute :name             , :kind_of => String    , :name_attribute => true
attribute :collect_time     , :kind_of => Integer   , :default => 40
attribute :threshold_time   , :kind_of => Integer   , :default => 60
attribute :use_regex        , :kind_of => [TrueClass, FalseClass], :default => false
attribute :source           , :kind_of => String
attribute :metrics          , :kind_of => Hash

def initialize(*args)
  super
  @action = :deploy
end 
