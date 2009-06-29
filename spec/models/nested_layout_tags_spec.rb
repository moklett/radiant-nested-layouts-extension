require File.dirname(__FILE__) + '/../spec_helper'

describe "Nested Layout Tags" do
  before :each do
    setup_page_and_layouts
  end

  it 'should render without layout' do
    @page.layout = nil
    @page.render.should == 'Hello World!'
  end
  
  it 'should render within layout using normal +content+ tag' do
    @page.layout = @layouts[:traditional]
    @page.render.should == %{<html><body>Hello World!</body></html>}
  end
  
  it 'should render within layout using the +content_for_layout+ tag' do
    @page.layout = @layouts[:master]
    @page.render.should == %{<html><body>Hello World!</body></html>}
  end

  it 'should render within layout nested 1 deep' do
    @page.layout = @layouts[:nest1]
    @page.render.should == %{<html><body><div id="nest1">Hello World!</div></body></html>}
  end

  it 'should render within layout nested 2 deep' do
    @page.layout = @layouts[:nest2]
    @page.render.should == %{<html><body><div id="nest1"><div id="nest2">Hello World!</div></div></body></html>}
  end
  
  it 'should render within layouts with multi-word names' do
    @page.layout = @layouts[:nested_multiword]
    @page.render.should == %{<html><body><div id="multiword"><div id="nested-multiword">Hello World!</div></div></body></html>}
  end
  
  context "with <r:layout/> tags" do
    before(:each) do
      @page.parts.first.content = "<r:layout/>"
    end

    it 'should render correctly for a traditional layout' do
      @page.layout = @layouts[:traditional]
      @page.render.should == %{<html><body>traditional</body></html>}
    end

    it 'should render correctly for a non-nested layout' do
      @page.layout = @layouts[:master]
      @page.render.should == %{<html><body>master</body></html>}
    end
    
    it 'should render correctly for a nested layout' do
      @page.layout = @layouts[:nest1]
      @page.render.should == %{<html><body><div id="nest1">nest1</div></body></html>}
    end
    
  end
end

def setup_page_and_layouts
  @page = Page.new(
    :title => "Home"
  )
  @page.parts.build(
    :name => "body",
    :content => "Hello World!"
  )
  @page.save
  
  @layouts = {
    :traditional => Layout.create(
      :name => "traditional",
      :content => %{<html><body><r:content/></body></html>}
    ),
    :master => Layout.create(
      :name => "master",
      :content => %{<html><body><r:content_for_layout/></body></html>}
    ),
    :nest1 => Layout.create(
      :name => "nest1",
      :content => %{<r:inside_layout name="master"><div id="nest1"><r:content_for_layout/></div></r:inside_layout>}
    ),
    :nest2 => Layout.create(
      :name => "nest2",
      :content => %{<r:inside_layout name="nest1"><div id="nest2"><r:content_for_layout/></div></r:inside_layout>}
    ),
    :multiword => Layout.create(
      :name => "Multi Word",
      :content => %{<r:inside_layout name="master"><div id="multiword"><r:content_for_layout/></div></r:inside_layout>}
    ),
    :nested_multiword => Layout.create(
      :name => "Nested Multi Word",
      :content => %{<r:inside_layout name="Multi Word"><div id="nested-multiword"><r:content_for_layout/></div></r:inside_layout>}
    )
  }
end
    