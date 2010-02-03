##################################
# parse shakespeare-monologues.org
##################################
require 'nokogiri'
require 'open-uri'
require 'ruby-debug'


def scene_body(reftext)
  begin
    return '' unless reftext
    m = reftext.match(/\b([IVX]+)\s+([ivx1]+)\s+(\d+)\b/i)
    if m and m[1] and m[2] and m[3]
      ref = [ m[1].upcase, m[2].gsub(/1/, 'i').downcase, m[3] ].join
    end
    return ref
  rescue => e
    puts "Error building link to body: #{e.message}"
    return ''
  end
end

def parse_monologues(server, mono_page)
  doc = Nokogiri::HTML.parse(open(server + mono_page))
  # puts doc.class.to_s + ' from ' + server + mono_page
  play = doc.xpath('//h1').inner_text.strip
  monologue_table = doc.xpath('//tr')
  #monologue_table = doc.xpath('//table[1]').children[1]
  #puts monologue_table.children.size
  monos = []
  monologue_table.each do |row|
    next unless row.to_s.match(/\bProse\b|\bVerse\b/)
    nodes = row.children.select{|n| n.class == Nokogiri::XML::Element }
    if nodes[0].inner_text.length < 200
      character = nodes[0].inner_text.sub(/intercut/, ' (intercut)').strip
      type = nodes[1].inner_text.strip rescue ''
      name = nodes[2].xpath('i')[0].inner_text.strip rescue nodes[2].inner_text
      reftext = nodes[3].xpath('a').inner_text.strip rescue ''
      reflink = nodes[3].xpath('a')[0].attributes['href'].text.strip rescue ''
      fc = nodes[4].xpath('script').to_html rescue ''
      mono = [character, type, name, reftext, reflink, fc]
      monos << mono
  #    puts server + mono_page + ref + '.htm' if ref
    end
  end
  return [monos, play]
end

def insert_monologues(server, mono_page, monos, play_id)
  added = 0
  monos.each do |mono|
    case mono_page
    when /^\/men/
      gender = 3
    when /^\/women/
      gender = 2
    end
    body_url = server + mono_page + scene_body(mono[3]) + '.htm' rescue ''
    begin
      body = open(body_url).read

      name = mono[2] || ''
      character = mono[0] || ''
      style = mono[1] || ''
      section = mono[3] || ''
      link = mono[4] || ''

      Monologue.create!(
        :play_id => play_id,
        :name => name,
        :character => character,
        :gender_id => gender,
        :style => style,
        :body => body,
        :section => section,
        :link => link
      )
      added += 1
      puts "  #{name} (#{character})"
    rescue => e
      print "Error adding monologue: #{name}\n #{e.message} "
      print body_url if e.message.strip == "404 Not Found"
      puts
    end
  end
end

def insert_play(play)
  play = 'Loves Labour\'s Lost' if play == 'Loves Labor\'s Lost'
  play = 'Twelfth Night, Or What You Will' if play == 'Twelfth Night, Or what you will.'
  play = 'Henry IV, part 1' if play.match( /Henry IV/i )

  begin
    Play.create(:title => play, :author_id => 1)
    return Play.find_by_title(play).id
  rescue => e
    if play
      puts "Error adding play: #{play}\n #{e.message}"
    else
      puts "Error adding play: #{e.message}"
    end
  end
end

server = 'http://shakespeare-monologues.org'
mono_pages = [
  '/women/hamlet/', '/men/hamlet/',
  '/women/midsummer/', '/men/midsummer/',
  '/women/macbeth/', '/men/macbeth/',
  '/women/AllsWell/', '/men/AllsWell/',
  '/women/AsYouLikeIt/', '/men/AsYouLikeIt/',
  '/women/Errors/', '/men/Errors/',
  '/women/Cymbeline/', '/men/Cymbeline/',
  '/women/LLL/', '/men/LLL/',
  '/women/TMofV/', '/men/merchant/',
  '/women/MuchAdo/', '/men/MuchAdo/',
  '/women/shrew/', '/men/shrew/',
  '/women/12thNight/', '/men/12thNight/',
  '/women/HenryIVi/', '/men/HenryIVi/',
  '/women/AandC/', '/men/AandC/',
  '/women/RandJ/', '/men/RandJ/',
  '/women/othello/', '/men/othello/']
# gender == 1 both, 2 women, 3 men
mono_pages.each do |mono_page|
  monos, play = parse_monologues(server, mono_page)
  puts
  puts "PAGE: #{play} has #{monos.size} monologes (#{mono_page})"
  play_id = insert_play(play)
  mono_count = Monologue.count
  insert_monologues(server, mono_page, monos, play_id)
  puts "END PAGE: Inserted #{Monologue.count - mono_count} of #{monos.size} monologues found"
  puts

end
