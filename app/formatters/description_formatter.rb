class DescriptionFormatter
  def self.format(opts = {})
    raise ArgumentError.new("DescriptionFormatter expects :using arg to be a single value") if opts.keys.many?

    str = opts.values.first
    str.gsub!("|%", "%")
    str.gsub!("|", "&nbsp;")
    str.gsub!(/&(?!#|nbsp)/, '&amp;')
    str.gsub!("!1!", "<br />")
    str.gsub!("!X!", "&times;")
    str.gsub!("!x!", "&times;")
    str.gsub!("!o!", "&deg;")
    str.gsub!("!O!", "&deg;")
    str.gsub!("!>=!", "&ge;")
    str.gsub!("!<=!", "&le;")
    str.gsub!("\n \n", "<br/>")
    str.gsub!("\n", "<br/>")
    str.gsub! /@(.)/ do
      "<sub>#{$1}</sub>"
    end
    str.gsub! /\$(.)/ do
      "<sup>#{$1}</sup>"
    end
    str.strip
    str.html_safe
  end
end
