class NestedLayoutsExtension < Radiant::Extension
  version "0.1"
  description "An extension for Radiant CMS which provides tags for creating nested layouts. "
  url "http://webadvocate.com/radiant-nested-layouts-extension"
  
  def activate
    require 'lib/nested_layout_tags.rb'
    Page.send :include, NestedLayoutTags
  end
  
  def deactivate
  end
  
end