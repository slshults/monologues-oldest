##################################
# parse shakespeare-monologues.org
##################################
require 'nokogiri'
require 'open-uri'
require 'ruby-debug'
require 'timeout'


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
  begin
    doc = Nokogiri::HTML.parse(open(server + mono_page))
  rescue => e
    puts "Failed to open monologue page url: #{server + mono_page}"
    raise e
  end
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
      first_line = nodes[2].xpath('i')[0].inner_text.strip rescue nodes[2].inner_text
      first_line = nil if first_line.match(/skin\['CONTENT/)
      reftext = nodes[3].xpath('a').inner_text.strip rescue ''
      reflink = nodes[3].xpath('a')[0].attributes['href'].text.strip rescue ''
      # fc = nodes[4].xpath('script').to_html rescue ''
      # mono = [character, type, first_line, reftext, reflink, fc]
      mono = [character, type, first_line, reftext, reflink]
      monos << mono
  #    puts server + mono_page + ref + '.htm' if ref
    end
  end
  return [monos, play]
end

def parse_and_insert_oldmonologues(server, oldmono_page)
  oldmono_count = 0
  doc = Nokogiri::HTML.parse(open(server + oldmono_page))
  case oldmono_page
  when /^\/women/ 
    gender_id = 2
    gender = 'women'
  when /^\/men/
    gender_id = 3
    gender = 'men'
  end
  play_tags = doc.xpath('//h2')
  play_tags.each do |play_tag|
    added = 0
    play_table = play_tag.next.next
    play_name = play_tag.inner_text.strip
    play_id = insert_play(play_name)
    monologues = play_table.xpath('tr')
    print "BEGIN  #{play_name} has #{monologues.size} #{gender} monologues"
    monologues.each do |mono|
      begin
        cells = mono.xpath('td')
        intercut_yes = cells[0].inner_text.match(/^.+?\s*(\(intercut\))\s*$/)
        if intercut_yes
          character = cells[0].inner_text.match(/^(.+?)\s*\(intercut\)\s*$/)[1].strip
          intercut = 1
        else
          character = cells[0].inner_text.strip || ''
          intercut = 0
        end
        style = cells[1].inner_text.strip rescue nil
        if cells[2].xpath('a/i').inner_text.length > 1
          first_line = cells[2].xpath('a/i').inner_text.strip
        elsif cells[2].xpath('i').inner_text.length > 1
          first_line = cells[2].xpath('i').inner_text.strip
        else
          raise "\nCannot find Monologue first_line in html for #{character}"
        end
        pdf_link = cells[2].xpath('a')[0]['href'].strip rescue nil
        location = cells[3].xpath('a').inner_text.strip rescue nil
        body_link = cells[3].xpath('a')[0]['href'].strip rescue nil
      rescue => e
        print "\nError parsing monologue for #{character}\n #{e.message} "
        puts
      end

      if Monologue.find_by_first_line_and_play_id(first_line, play_id)
        print '.'
        next
      end

      begin
        Monologue.create!(
          :play_id => play_id,
          :first_line => first_line,
          :character => character,
          :gender_id => gender_id,
          :style => style,
          :body => nil,
          :location => location,
          :pdf_link => pdf_link,
          :body_link => body_link,
          :intercut => intercut
        )
        added += 1
        print '#'
        #puts "  #{first_line} (#{character})"
      rescue => e
        print "\nError adding monologue for #{character}\n #{e.message} "
        puts
      end
    end
    puts "\nEND Inserted #{added} of #{monologues.size}"
    puts
    oldmono_count += added
  end
  puts
  puts "Inserted #{oldmono_count} Old Monologues"
end

def insert_monologues(server, mono_page, monos, play_id)
  added = 0
  style_js_text_array = open(server + mono_page + 'style.js').read.scan(/^Text\[\d+\].+?\n\n/m)
  monos.each_index do |i|
    mono = monos[i]
    case mono_page
    when /^\/men/
      gender = 3
    when /^\/women/
      gender = 2
    end
    begin
      first_line = mono[2] || ''
      intercut_yes = mono[0].match(/^.+?\s*(\(intercut\))\s*$/)
      if intercut_yes
        character = mono[0].match(/^(.+?)\s*\(intercut\)\s*$/)[1].strip
        intercut = 1
      else
        character = mono[0] || ''
        intercut = 0
      end
      style = mono[1] || ''
      location = mono[3] || ''
      body_link = mono[4] || ''

      if Monologue.find_by_first_line_and_play_id(first_line, play_id)
        print '.'
        next
      end

      scene_ref_page = style_js_text_array[0].match(/src=["'](.+?)["']/)[1]
      pdf_link = style_js_text_array[0].match(/href=["'](.+?)["']/)[1]
      body_local_link = server + mono_page + scene_ref_page rescue ''
      body = nil
      begin
        Timeout::timeout(5){
          body = open(body_local_link).read
        }
      rescue Timeout::Error => e
        puts "\nTimeout error trying to retrieve body for #{first_line}"
        next
      end

      Monologue.create!(
        :play_id => play_id,
        :first_line => first_line,
        :character => character,
        :gender_id => gender,
        :style => style,
        :body => body,
        :location => location,
        :pdf_link => pdf_link,
        :body_link => body_link,
        :intercut => intercut
      )
      added += 1
      print '#'
      #puts "  #{first_line} (#{character})"
    rescue => e
      print "\nError adding monologue: #{mono}\n #{e.message} "
      print body_url if e.message.strip == "404 Not Found"
      puts
    end
  end
end

def insert_play(play)
  play = 'Twelfth Night, Or What You Will' if play.match(/^Twelfth Night/i)
  play = 'Julius Caesar' if play.match(/^Julius /i)
  play = 'Loves Labours Lost' if play.match(/^Loves Lab/i)
  play = 'Pericles, Prince of Tyre' if play.match(/^Pericles/i)
  play = 'Henry IV, i' if play.match( /^Henry IV/i )

  if play.match(/Other Works/)
    puts "Other Works is not a play! Skipping..."
    return nil
  end
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
  '/women/othello/', '/men/othello/'
]

# gender == 1 both, 2 women, 3 men
puts "\nParsing Monologue pages"
puts
mono_pages.each do |mono_page|
  monos, play = parse_monologues(server, mono_page)
  print "BEGIN: #{play} has #{monos.size} monologes (#{mono_page}) "
  play_id = insert_play(play)
  mono_count = Monologue.count
  insert_monologues(server, mono_page, monos, play_id)
  puts "\nEND: Inserted #{Monologue.count - mono_count} of #{monos.size}"
  puts
  sleep 3
end

puts "\nParsing OLD Mens Monologue page"
puts
parse_and_insert_oldmonologues(server, '/mensmonos.old.shtml')

puts "\n\nParsing OLD Womens Monologue page"
puts
parse_and_insert_oldmonologues(server, '/womensmonos.old.htm')
