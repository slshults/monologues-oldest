# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Gender.create!(:name => 'Both')
Gender.create!(:name => 'Women')
Gender.create!(:name => 'Men')
Author.create!(:name => 'Shakespeare')


##################################
# parse shakespeare-monologues.org
##################################
require 'nokogiri'
require 'open-uri'
require 'ruby-debug'


def scene_body(reftext)
  return '' unless reftext
  m = reftext.match(/\b([IVX]+) ([ivx1]+) (\d+)\b/)
  if m and m[1] and m[2] and m[3]
    ref = [ m[1], m[2], m[3] ].join
  end
  return ref
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
      name = nodes[2].xpath('i')[0].inner_text.strip rescue ''
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

def insert_monologues(server, mono_page, monos)
  monos.each do |mono|
    shake = Author.find_by_name('Shakespeare')
    hamlet = Play.find_by_title('Hamlet')
    case mono_page
    when /^\/men/
      gender = 3
    when /^\/women/
      gender = 2
    end
    begin
      body = open(server + mono_page + scene_body(mono[3]) + '.htm').read
      Monologue.create!(
        :play_id => hamlet.id,
        :name => mono[2],
        :character => mono[0],
        :gender_id => gender,
        :style => mono[1],
        :body => body,
        :section => mono[3],
        :link => mono[4]
      )
      puts "Added #{mono[2]}"
    rescue => e
      #logger.warn "Error adding monologe: #{mono[2]}\n e.message"
      puts "Error adding monologue: #{mono[2]}\n #{e.message}"
    end
  end
end

def insert_play(play)
  Play.create(:title => play, :author_id => 1)
end

server = 'http://shakespeare-monologues.org'
mono_pages = ['/women/hamlet/', '/men/hamlet/',
  '/women/midsummer/', '/men/midsummer/',
  '/women/macbeth/', '/men/macbeth/',
  '/women/AllsWell/', '/men/AllsWell/',
  '/women/AsYouLikeIt/', '/men/AsYouLikeIt/',
  '/women/Errors/', '/men/Errors/',
  '/women/Cymbeline/', '/men/Cymbeline/',
  '/women/LLL/', '/men/LLL/',
  '/women/merchant/', '/men/merchant/',
  '/women/MuchAdo/', '/men/MuchAdo/'  ]
# gender == 1 both, 2 women, 3 men
mono_pages.each do |mono_page|
  monos, play = parse_monologues(server, mono_page)
  puts "#{play} had #{monos.size} monologes (#{mono_page})"
  insert_play(play)
  insert_monologues(server, mono_page, monos)
end



#shake = Author.find_by_name('Shakespeare')
#hamlet = Play.create!(:title => 'Hamlet', :author_id => shake.id)
#twelfth = Play.create!(:title => 'Twelfth Night', :author_id => shake.id)
#romeo = Play.create!(:title => 'Romeo and Juliet', :author_id => shake.id)





#Monologue.create!(
#  :name => 'Rebellious subjects, enemies to peace',
#  :character => 'Prince',
#  :play_id => romeo.id,
#  :gender_id => 3,
#  :style => 'Verse',
#  :body => %q(Rebellious subjects, enemies to peace,
#Profaners of this neighbour-stained steel,--
#Will they not hear? What, ho! you men, you beasts,
#That quench the fire of your pernicious rage
#With purple fountains issuing from your veins,
#On pain of torture, from those bloody hands
#Throw your mistemper'd weapons to the ground,
#And hear the sentence of your moved prince.
#Three civil brawls, bred of an airy word,
#By thee, old Capulet, and Montague,
#Have thrice disturb'd the quiet of our streets,
#And made Verona's ancient citizens
#Cast by their grave beseeming ornaments,
#To wield old partisans, in hands as old,
#Canker'd with peace, to part your canker'd hate:
#If ever you disturb our streets again,
#Your lives shall pay the forfeit of the peace.
#For this time, all the rest depart away:
#You Capulet; shall go along with me:
#And, Montague, come you this afternoon,
#To know our further pleasure in this case,
#To old Free-town, our common judgment-place.
#Once more, on pain of death, all men depart.) )
#
#Monologue.create!(:name => 'If music be the food of love, play on', :character => 'Orsino', :play_id => twelfth.id, :gender_id => 3, :style => 'Verse',
#  :body => %q(If music be the food of love, play on;
#Give me excess of it, that, surfeiting,
#The appetite may sicken, and so die.
#That strain again! it had a dying fall:
#O, it came o'er my ear like the sweet sound,
#That breathes upon a bank of violets,
#Stealing and giving odour! Enough; no more:
#'Tis not so sweet now as it was before.
#O spirit of love! how quick and fresh art thou,
#That, notwithstanding thy capacity
#Receiveth as the sea, nought enters there,
#Of what validity and pitch soe'er,
#But falls into abatement and low price,
#Even in a minute: so full of shapes is fancy
#That it alone is high fantastical.) )
#
#Monologue.create!(:name => 'O what a noble mind is here o\'erthrown', :character => 'Ophelia', :play_id => hamlet.id, :gender_id => 2, :style => 'Verse',
#  :body => %q(O, what a noble mind is here o'erthrown!
#The courtier's, scholar's, soldier's, eye, tongue, sword,
#Th' expectancy and rose of the fair state,
#The glass of fashion and the mould of form,
#Th' observ'd of all observers- quite, quite down!
#And I, of ladies most deject and wretched,
#That suck'd the honey of his music vows,
#Now see that noble and most sovereign reason,
#Like sweet bells jangled, out of tune and harsh;
#That unmatch'd form and feature of blown youth
#Blasted with ecstasy. O, woe is me
#T' have seen what I have seen, see what I see!) )