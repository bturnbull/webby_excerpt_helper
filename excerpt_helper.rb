require 'rexml/parsers/pullparser'
require 'htmlentities'

module ExcerptHelper

  # raised when tags could not be fixed up by hpricot
  class InvalidHtml < RuntimeError; end
  
  def excerpt(input, opts = {})
    tag = (opts[:tag] || (opts[:delimiter].nil? ? 'p' : '')).downcase
    count = opts[:count] || 2
    delimiter = (opts[:delimiter] || 'end excerpt').downcase
    
    begin
      parser = REXML::Parsers::PullParser.new(input)
      encoder = HTMLEntities.new('xhtml1')
      tags, output, remaining = [], '', count

      while parser.has_next? && count > 0
        element = parser.pull
        case element.event_type
        when :start_element
          output << rexml_element_to_tag(element)
          tags.push element[0]
        when :end_element
          count -= 1 if tags.last.downcase == tag.downcase
          output << "</#{tags.pop}>"
        when :text
          text = encoder.decode(element[0])
          output << encoder.encode(text)
        when :comment
          count = 0 if encoder.decode(element[0]).strip.downcase == delimiter
        end
      end

      tags.reverse.each {|t| output << "</#{t}>"}
      output

    rescue REXML::ParseException => e
      fixed_up = Hpricot(input, :fixup_tags => true).to_html
      raise InvalidHtml, "Could not fixup invalid html. #{e.message}" if fixed_up == input
      input = fixed_up
      retry
    end

  end

private

  def rexml_element_to_tag(element)
    "<#{element[0]}#{element[1].inject(""){|m,(k,v)| m << %{ #{k}="#{v}"}} unless element[1].empty?}>"
  end

end
