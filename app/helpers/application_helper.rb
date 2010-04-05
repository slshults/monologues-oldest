# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def link_to_monologue( monologue )
    if monologue.body
      link_to( monologue.first_line, monologue )
    else
      "<span class='no-link'>#{monologue.first_line}</span>"
    end
  end

  def link_to_monologue_pdf( monologue )
    if monologue.pdf_link
      "<a href='#{monologue.pdf_link}'><img title='pdf' alt='pdf' valign='middle' src='/images/print.gif' border='0' /></a>"
    else
      "<img title='pdf' alt='pdf' valign='middle' src='/images/print_x.gif' border='0' />"
    end
  end

  def link_to_monologue_location( monologue )
    if monologue.body_link
      "<a href='#{h monologue.body_link}'>#{h monologue.location}</a>"
    else
      h monologue.body_link
    end
  end
end
