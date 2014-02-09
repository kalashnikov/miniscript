require 'csv'
require 'open-uri'
require 'nokogiri'

allList = {}
CSV.foreach(ARGV[0]) do |line| 
   next if !line[0]
   allList[line[1]] = line[0]
end

puts
puts "------"
puts 

allList.each do |k,v|
    puts "## #{k}"
    doc = Nokogiri::HTML(open(v))
    row = doc.xpath('//html/body/table/tr[3]/td[3]/p').each do |l|

#        next if !l.attributes["align"]
        next if l.content.include?("google") or l.content.include?("--")
        next if l.content.chomp.empty?
        next if l.content.include?("世界60秒巡り > 都道府県巡り >")
        break if l.content.include?("の民話・昔話")

        str = l.content.chomp
#        str = str.gsub!(/[\t]{2,}/,"  + ") if str=~/[\t]{2,}/
#        next if str.chomp.empty?
        str = str.gsub!(/[・→]/,"\t\t\t ") if str=~/[・→]/
        next if str.chomp.empty?
        puts "- #{str}"

        # GIF
        img = l.xpath('./img/@src').to_s
        if !img.empty?
            print "- "
            l.xpath('./img/@src').each do |i|
                uri  = v[0,v.rindex(/\//)]
                type = i.content.split('.').last
                print "![#{type}](#{uri}/#{i}) "
            end
            print "\n"
        end

        # JPG
        img = l.xpath('./span/img/@src').to_s
        if !img.empty?
            print "- "
            l.xpath('./span/img/@src').each do |i|
                uri = v[0,v.rindex(/\//)]
                type = i.content.split('.').last
                print "![#{type}](#{uri}/#{i}) "
            end
            print "\n"
        end
    end
    puts 
    puts "-------" 
    puts 
end


#allList.each do |k,v|
#end
