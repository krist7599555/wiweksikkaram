require "nokogiri"
require "httparty"

module DekdUtils
  def self.fetch_post(chapter)
    url = "https://writer.dek-d.com/dekdee/writer/viewlongc.php?id=2485901&chapter=#{chapter}"
    response = HTTParty.get(url)
    # Check for a successful response (HTTP status 200)
    raise Exception.new "Scape Error [#{response.code}] on (#{url})" unless response.code == 200
    # 2. Parse the HTML using Nokogiri
    doc = Nokogiri::HTML(response.body)

    # 3. Use CSS selectors or XPath to find the desired element
    # This finds the first h1 element on the page
    out = {
      chapter: chapter,
      url: url,
      content: doc.css("#story-content p").map do |p|
        ("<p>" + p.text + "</p>")
        .gsub("&ZeroWidthSpace;", "")
        .gsub("๰", "ฌ")
        .gsub("๪", "ฆ")
        .gsub("๵", "ฑ")
        .gsub("๲", "ฏ")
        .gsub("๯", "ซ")
        .gsub("๭", "ฉ")
        .gsub("๳", "ฏ")
        .gsub("๮", "ช")
        .gsub("๥", "ก")
        .gsub("๦", "ข")
        .gsub("๨", "ค")
        .gsub("๹", "ต")
        .gsub("๸", "ด")
        .gsub("๴", "ฐ")
        .gsub("๷", "ณ")
        .gsub("๫", "ง")
        .gsub("๱", "ญ")
        .gsub("๬", "จ")
      end.join,
      book: doc.at_css(".chapter-box-wrapper .novel-name")&.text,
      title: doc.at_css(".chapter-box-wrapper .chaptername")&.text,
      date: doc.at_css(".chapter-box-wrapper .chapter-metainfo-wrapper")&.text
    }
    out
  end
end
