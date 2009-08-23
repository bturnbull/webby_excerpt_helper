ExcerptHelper for Webby
=======================

This is a helper for [Webby](http://webby.rubyforge.org/) that excerpts the leading content of a rendered HTML block.  It will close any dangling HTML tags at the point of cutoff.  It borrows heavily from the [truncate_html Rails helper](http://github.com/ianwhite/truncate_html/tree/master) by [Ian White](http://github.com/ianwhite), itself based on code by [Mike Burns](http://mikeburnscoder.wordpress.com/2006/11/11/truncating-html-in-ruby/).

Installation
------------

Copy <code>excerpt_helper.rb</code> into the Webby project's <code>lib</code> directory.  In your Webby Sitefile:

    require 'lib/excerpt_helper'
    Webby::Helpers.register(ExcerptHelper)

Examples
--------

Given the following HTML:

    foo = <div><h1>A Header</h1><p>Paragraph one.</p><!--break--><p>Paragraph two.</p></div>

    excerpt(foo)
    => <div><h1>A Header</h1><p>Paragraph one.</p><p>Paragraph two.</p></div>

    excerpt(foo, :count => 1)
    => <div><h1>A Header</h1><p>Paragraph one.</p></div>

    excerpt(foo, :count => 1, :tag => 'h1')
    => <div><h1>A Header</h1></div>

    excerpt(foo, :delimiter => 'break')
    => <div><h1>A Header</h1><p>Paragraph one.</p></div>


