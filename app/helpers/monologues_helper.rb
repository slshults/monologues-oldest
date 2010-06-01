module MonologuesHelper

  def list_monologues( monologues )
    header = <<-HEADER
    <div>
      <table width="580" style="text-align: left;" cellpadding="1px">
        <tr>
          <th style="font-size: 80%;">Character</th>
          <th width="420" style="font-size: 80%;">First Line</th>
          <th style="font-size: 80%;">Act & Sc</th>
          <th style="font-size: 80%;">pdf</th>
        </tr>
    HEADER
    rows = []
    for monologue in monologues
      row = ''
      row << "<tr id='#{cycle('odd-row', 'even-row')}'>"
      row << "\n<td width='90' style='vertical-align: top;'> #{monologue.character} <br/>"
      row << "\n<span style='font-size: 60%;'>"
      row << "#{h monologue.style} #{monologue.intercut_label} <br/>"
      row << "#{link_to( h(monologue.play.title), play_path(monologue.play) )}"
      if session[:user_id]
        row << "\n<br/> #{link_to 'edit', edit_monologue_path(monologue)}"
      end
      row << "</span>"
      row << "</td>"
      row << "\n<td width='420' style='font-size: 100%;' style='vertical-align: top;'>"
      row << "\n<span id='preview_mono_#{monologue.id}'>"
      row << "#{link_to_remote monologue.first_line,
                            :update => 'preview_mono_' + monologue.id.to_s,
                            :url => { :action => 'preview', :id => monologue.id }}"
      row << "</span>"
      row << "</td>"
      row << "\n<td width='60' valign='top' align='right' style='font-size: 70%;'>"
      row << "#{link_to_monologue_location( monologue )}"
      row << "</td>"
      row << "\n<td  valign='top' width='20'>"
      row << "#{link_to_monologue_pdf( monologue )}"
      row << "</td>"
      row << "</tr>"
      rows << row
    end
    footer = "</table></div>"
    return "#{header} #{rows.join("\n")} #{footer}"
  end
end
