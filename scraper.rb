require 'scraperwiki'
require 'nokogiri'

class Collection
    def initialize(name,url)
        @url = url
        @name = name
        @titles = []
    end
    
    attr_reader :name, :url
    attr_accessor :titles
    
    def getTitles
        html = ScraperWiki.scrape(@url)
        doc = Nokogiri::XML(html)
        doc.xpath("//a[contains(@href, 'titles')]/").each do |t|
            @titles.push(Title.new(t.inner_text.strip,t.href))
        end
    end
end
  
class Title
  def initialise(title,url)
    @title = title
    @url = url
  end
  
  attr_reader :title, :url
  attr_accessor :coverage, :publisher, :issn, :publisher_url, :frequency, :notes
  
  def getDetails
    
  end
end

puts "Starting..."
url = "http://home.heinonline.org/content/list-of-libraries/"
puts url
html = ScraperWiki.scrape(url)
doc = Nokogiri::HTML(html)
doc.xpath("//dd/a").each do |t|
    puts "Testing"
    puts t.attribute("href")
end
