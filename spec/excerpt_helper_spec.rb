#require 'excerpt_helper'
require File.expand_path(File.join(File.dirname(__FILE__), '../excerpt_helper'))
#require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe ExcerptHelper do
  include ExcerptHelper

  describe "use cases" do
    def self.with_opts_should_equal(str, opts = {})
      it "#{opts}, should equal #{str}" do
        excerpt(@html, opts).should == str
      end
    end

    describe "html: <p>one</p><p>two</p><p>three</p>, opts: " do
      before { @html = '<p>one</p><p>two</p><p>three</p>' }

      with_opts_should_equal '<p>one</p>', :count => 1
      with_opts_should_equal '<p>one</p><p>two</p>'
      with_opts_should_equal '<p>one</p><p>two</p>', :count => 2
      with_opts_should_equal '<p>one</p><p>two</p><p>three</p>', :count => 3
      with_opts_should_equal '<p>one</p><p>two</p><p>three</p>', :count => 3, :tag => 'p'
      with_opts_should_equal '<p>one</p><p>two</p><p>three</p>', :count => 2, :tag => 'div'
    end

    describe "html: <p>one</p><!--end excerpt--><p>two</p><p>three</p>, opts: " do
      before { @html = '<p>one</p><!--end excerpt--><p>two</p><p>three</p>' }

      with_opts_should_equal '<p>one</p>'
      with_opts_should_equal '<p>one</p>', :count => 2
      with_opts_should_equal '<p>one</p><p>two</p>', :count => 2, :tag => 'p', :delimiter => 'foo'
      with_opts_should_equal '<p>one</p><p>two</p><p>three</p>', :count => 2, :delimiter => 'foo'
    end

    describe "html: <div><p>one</p><!--end excerpt--><p>two</p><p>three</p></div>, opts: " do
      before { @html = '<div><p>one</p><!--end excerpt--><p>two</p><p>three</p></div>' }

      with_opts_should_equal '<div><p>one</p></div>'
      with_opts_should_equal '<div><p>one</p></div>', :count => 2
      with_opts_should_equal '<div><p>one</p><p>two</p></div>', :count => 2, :tag => 'p', :delimiter => 'foo'
    end

    describe "html: <p>one <strong>two</strong></p><p>three</p>, opts: " do
      before { @html = '<p>one <strong>two</strong></p><p>three</p>' }

      with_opts_should_equal '<p>one <strong>two</strong></p>', :count => 1, :tag => 'p'
    end

    describe '(incorrect) html: <p>one <strong>two</p><p>three</p>, opts:' do
      before { require 'Hpricot'; @html = '<p>one <strong>two</p><p>three</p>' }

      with_opts_should_equal '<p>one <strong>two</strong></p><p>three</p>'
    end

    describe '(incorrect) html: This is malformed</p>, opts: '
    #describe '(incorrect) html: This is malformed</p>, opts: ' do
    #  before { @html = 'This is malformed</p>' }
    #  
    #  with_opts_should_equal 'This is malformed'
    #  
    #  it "should raise the REXML error inside a ExcerptHelper exception" do
    #    lambda { excerpt(@html) }.should raise_error(ExcerptHelper::InvalidHtml)
    #  end
    #end

  end
end
