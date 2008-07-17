module NestedLayoutTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

  tag 'inside_layout' do |tag|
    if name = tag.attr['name']
      # Prepare the stacks
      tag.globals.nested_layouts_content_stack ||= []
      tag.globals.nested_layouts_layout_stack ||= []
      
      # Find the layout
      name.strip!
      if layout = Layout.find_by_name(name)
        # Track this layout on the stack
        tag.globals.nested_layouts_layout_stack << name
        
        # Save contents of inside_layout for later insertion
        tag.globals.nested_layouts_content_stack << tag.expand
        
        # Set the page layout that Radiant should use for rendering, which is different than the actual
        # page's layout when layouts are nested.  The final/highest +inside_layout+ tag will set or 
        # overwrite this value for the last time.
        tag.globals.page.layout = layout
        tag.globals.page.render
      else
        raise TagError.new(%{Error (nested_layouts): Parent layout "#{name.strip}" not found for "inside_layout" tag})
      end
    else
      raise TagError.new(%{Error (nested_layouts): "inside_layout" tag must contain a "name" attribute})
    end
  end

  tag 'content_for_layout' do |tag|
    tag.globals.nested_layouts_content_stack ||= []
    
    # return the saved content if any, or mimic a default +<r:content/>+ tag (render the body part)
    tag.globals.nested_layouts_content_stack.pop || tag.globals.page.render_snippet(tag.locals.page.part('body'))
  end

end