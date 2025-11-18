require "nokogiri"

class PostController < ApplicationController
  def index
    @posts = Rails
      .public_path.join("dekd", "index.json")
      .then { |it| File.read it }
      .then { |it| JSON.parse it }
  end

  def show
    chapter = params[:id]
    @post = Rails
      .public_path.join("dekd", "chapter", "#{chapter}.html")
      .then { |it| File.read it }
      .then { |it| Nokogiri::HTML it }
      .then { |doc|
        {
          chapter: chapter,
          url: "https://writer.dek-d.com/dekdee/writer/viewlongc.php?id=2485901&chapter=#{chapter}",
          book: doc.at_css(".chapter-box-wrapper .novel-name")&.text,
          title: doc.at_css(".chapter-box-wrapper .chaptername")&.text,
          date: doc.at_css(".chapter-box-wrapper .chapter-metainfo-wrapper")&.text,
          content: doc
            .css("#story-content p")
            .map { |p|
              ("<p>" + p.text + "</p>")
              .gsub!("&ZeroWidthSpace;", "")
              .tr!("๰๪๵๲๯๭๳๮๥๦๨๹๸๴๷๫๱๬", "ฌฆฑฏซฉฏชกขคตดฐณงญจ")
            }
            .join
        }
      }
  end
end
