require "nokogiri"
require "httparty"

module DekdUtils
  def self.fetch_post(chapter)
    url = "https://writer.dek-d.com/dekdee/writer/viewlongc.php?id=2485901&chapter=#{chapter}"
    headers = {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Safari/537.36",
      "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      "Accept-Language" => "en-US,en;q=0.5",
      "Accept-Encoding" => "gzip, deflate, br",
      "Connection" => "keep-alive",
      "Upgrade-Insecure-Requests" => "1",
      "Cache-Control" => "max-age=0"
    }

    response = HTTParty.get(url, headers: headers)
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
      date: doc.at_css(".chapter-box-wrapper .chapter-metainfo-wrapper")&.text,
      scrape_status: response.code,
      scrape_html: doc.to_html
    }
    Rails.logger.debug(out.inspect)
    out
  end
end
