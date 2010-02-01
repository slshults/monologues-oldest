require 'ruby-debug'
$server = 'http://shakespeare-monologues.org'
$mono_page = '/men/hamlet/'

require 'open-uri'
#files = []
#open(server + mono_page) do |f|
#  f.each_line do |line|
#    line.scan(/\b([IVX]+) ([ivx]+) (\d+)\b/) do |act_scene_line|
#      files << act_scene_line.join
#    end
#  end
#end
#
#files.each do |file|
#  puts server + mono_page + file + '.htm'
#end

def scene_body(reftext)
  return '' unless reftext
  m = reftext.match(/\b([IVX]+) ([ivx1]+) (\d+)\b/)
  if m and m[1] and m[2] and m[3]
    ref = [ m[1], m[2], m[3] ].join
    open($server + $mono_page + ref + '.htm').read
  end
end

require 'nokogiri'
require 'pp'
doc = Nokogiri::HTML.parse(open($server + $mono_page))
monologue_table = doc.xpath('//tr')
#monologue_table = doc.xpath('//table[1]').children[1]
monos = []
monologue_table.each do |row|
  next unless row.to_s.include? 'Include the Google Friend Connect'
  nodes = row.children.select{|n| n.class == Nokogiri::XML::Element }
  if nodes[0].to_s.length < 100
    character = nodes[0].inner_text.sub(/intercut/, ' (intercut)').strip
    type = nodes[1].inner_text.strip rescue ''
    name = nodes[2].xpath('i')[0].inner_text.strip rescue ''
    #debugger
    reftext = nodes[3].xpath('a').inner_text.strip rescue ''
    reflink = nodes[3].xpath('a')[0].attributes['href'].text.strip rescue ''
    fc = nodes[4].xpath('script').to_html rescue ''
    mono = [character, type, name, reftext, reflink, fc]
    monos << mono
    #pp mono
#    puts server + mono_page + ref + '.htm' if ref
  end
end


monos.each do |mono|
  shake = Author.find_by_name('Shakespeare')
  hamlet = Play.find_by_title('Hamlet')
  begin
    body = scene_body(mono[3])
    Monologue.create!(
      :play_id => hamlet.id,
      :name => mono[2],
      :character => mono[0],
      :gender_id => 3,
      :style => mono[1],
      :body => body,
      :section => mono[3],
      :link => mono[4]
    )
  rescue => e
    puts e.message
  end
end