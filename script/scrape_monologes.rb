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
      name = nodes[2].xpath('i')[0].inner_text.strip rescue nodes[2].inner_text
      name = nil if name.match(/skin\['CONTENT/)
      reftext = nodes[3].xpath('a').inner_text.strip rescue ''
      reflink = nodes[3].xpath('a')[0].attributes['href'].text.strip rescue ''
      # fc = nodes[4].xpath('script').to_html rescue ''
      # mono = [character, type, name, reftext, reflink, fc]
      mono = [character, type, name, reftext, reflink]
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
    print "BEGIN OLDPLAY #{monologues.size} #{gender} Monologues for #{play_name} "
    monologues.each do |mono|
      begin
        cells = mono.xpath('td')
        character = cells[0].inner_text.strip
        style = cells[1].inner_text.strip rescue nil
        if cells[2].xpath('a/i').inner_text.length > 1
          name = cells[2].xpath('a/i').inner_text.strip
        elsif cells[2].xpath('i').inner_text.length > 1
          name = cells[2].xpath('i').inner_text.strip
        else
          raise "\nCannot find Monologue name in html for #{character}"
        end
        pdf_link = cells[2].xpath('a')[0]['href'].strip rescue nil
        ref_text = cells[3].xpath('a').inner_text.strip rescue nil
        ref_link = cells[3].xpath('a')[0]['href'].strip rescue nil
      rescue => e
        print "\nError parsing monologue for #{character}\n #{e.message} "
        puts
      end

      if Monologue.find_by_name_and_play_id(name, play_id)
        print '.'
        next
      end

      begin
        Monologue.create!(
          :play_id => play_id,
          :name => name,
          :character => character,
          :gender_id => gender_id,
          :style => style,
          :body => nil,
          :section => ref_text,
          :link => ref_link
        )
        added += 1
        print '#'
        #puts "  #{name} (#{character})"
      rescue => e
        print "\nError adding monologue for #{character}\n #{e.message} "
        puts
      end
    end
    puts "\nEND OLDPLAY Added #{added} of #{monologues.size} monologues"
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
      name = mono[2] || ''
      character = mono[0] || ''
      style = mono[1] || ''
      section = mono[3] || ''
      link = ''

      if Monologue.find_by_name_and_play_id(name, play_id)
        print '.'
        next
      end

      scene_ref_page = style_js_text_array[0].match(/src=["'](.+?)["']/)[1]
      link = style_js_text_array[0].match(/href=["'](.+?)["']/)[1]
      body_url = server + mono_page + scene_ref_page rescue ''
      body = nil
      begin
        Timeout::timeout(5){
          body = open(body_url).read
        }
      rescue Timeout::Error => e
        puts "\nTimeout error trying to retrieve body for #{name}"
        next
      end

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
      print '#'
      #puts "  #{name} (#{character})"
    rescue => e
      print "\nError adding monologue: #{mono}\n #{e.message} "
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
  print "BEGIN PAGE: #{play} has #{monos.size} monologes (#{mono_page}) "
  play_id = insert_play(play)
  mono_count = Monologue.count
  insert_monologues(server, mono_page, monos, play_id)
  puts "\nEND PAGE: Inserted #{Monologue.count - mono_count} of #{monos.size} monologues found"
end

oldmono_pages = [
  '/mensmonos.old.shtml', '/womensmonos.old.htm']

# gender == 1 both, 2 women, 3 men
oldmono_pages.each do |oldmono_page|
  parse_and_insert_oldmonologues(server, oldmono_page)
end
