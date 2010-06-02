module MonologuesHelper

  def list_monologues( monologues )
    header = <<-HEADER
    <div>
      <table id='monologue_list'>
        <tr>
          <th>Character</th>
          <th>First Line</th>
          <th>Act & Sc</th>
          <th>pdf</th>
        </tr>
    HEADER
    rows = []
    for monologue in monologues
      row = ''
      row << "<tr class='monologue_listing' id='#{cycle('odd-row', 'even-row')}'>"
      row << "\n<td><div class='monologue_character'>#{monologue.character}</div>"
      row << "\n<div class='monologue_detail'>"
      row << "#{h monologue.style} #{monologue.intercut_label} <br/>"
      row << "#{link_to( h(monologue.play.title), play_path(monologue.play) )}"
      if session[:user_id]
        row << "\n<br/> #{link_to 'edit', edit_monologue_path(monologue)}"
      end
      row << "</div>"
      row << "</td>"
      row << "\n<td class='monologue_firstline'>"
      row << "\n<span id='preview_mono_#{monologue.id}'>"
      row << "#{link_to_remote monologue.first_line,
                            :update => 'preview_mono_' + monologue.id.to_s,
                            :url => { :action => 'preview', :id => monologue.id }}"
      row << "</span>"
      row << "</td>"
      row << "\n<td class='monologue_actscene'>"
      row << "#{link_to_monologue_location( monologue )}"
      row << "</td>"
      row << "\n<td  class='monologue_pdflink'>"
      row << "#{link_to_monologue_pdf( monologue )}"
      row << "</td>"
      row << "</tr>"
      rows << row
    end
    footer = "</table></div>"
    return "#{header} #{rows.join("\n")} #{footer}"
  end
end
