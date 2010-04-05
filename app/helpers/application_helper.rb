# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def link_to_monologue_or_pdf( monologue )
    if monologue.body
      link_to( monologue.first_line, monologue )
    else
      link_to( monologue.first_line, monologue.pdf_link)
    end
  end
end
