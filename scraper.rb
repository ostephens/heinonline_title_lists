require 'scraperwiki'
require 'nokogiri'

class Collection
    def initialize(url)
        @url = url
        @titles = []
    end
    
    attr_reader :url
    attr_accessor :name,:titles
    
    def getDetails
        puts @url
        html = ScraperWiki.scrape(@url)
        doc = Nokogiri::HTML(html)
        doc.xpath("//h2").each do |n|
          @name = n.inner_text.strip
        end
        doc.xpath("//a[contains(@href, 'titles')]").each do |t|
            @titles.push(Ti.new(t.inner_text.strip,"http://home.heinonline.org"+t.attribute("href")))
        end
    end
    
    def saveCollection
      @titles.each do |t|
      data = {
      collection: @name,
      collectionurl: @url,
      title: t.title,
      titleurl: t.url
      }
      ScraperWiki::save_sqlite([], data)
end

class Ti
  def initialize(title,url)
    @title = title
    @url = url
  end
  
  attr_reader :title, :url
  attr_accessor :coverage, :publisher, :issn, :publisher_url, :frequency, :notes
  
  def getDetails
    puts @url    
  end
end

puts "Starting..."
url = "http://home.heinonline.org/content/list-of-libraries/"
puts url
html = ScraperWiki.scrape(url)
doc = Nokogiri::HTML(html)
doc.xpath("//dd/a[contains(@href,'titles')]").each do |t|
    c = Collection.new("http://home.heinonline.org"+t.attribute("href").to_s)
    c.getDetails
    c.titles.each do |x|
      x.getDetails
    end
    c.saveCollection
end
