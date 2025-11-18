require 'net/http'
require 'open-uri'
require 'fileutils' # For creating the chapter directory
require 'uri'       # For parsing the URL

# --- Configuration ---
BASE_URL = "https://writer.dek-d.com/dekdee/writer/viewlongc.php?id=2485901&chapter="
START_CHAPTER = 1
END_CHAPTER = 343
DOWNLOAD_DIR = "chapter"

# --- Setup ---
# 1. Ensure the download directory exists
FileUtils.mkdir_p(DOWNLOAD_DIR) unless Dir.exist?(DOWNLOAD_DIR)
puts "Starting chapter check and download..."

# --- Main Logic ---

(START_CHAPTER..END_CHAPTER).each do |chapter_number|
  filename = File.join(DOWNLOAD_DIR, "#{chapter_number}.html")
  url = "#{BASE_URL}#{chapter_number}"

  # 1. Check if the file exists and is not empty
  if File.exist?(filename) && !File.zero?(filename)
    puts "✅ Chapter #{chapter_number}: File exists and is not empty. Skipping."
    next
  end

  # 2. File either doesn't exist or is empty, proceed to download
  puts "⬇️ Chapter #{chapter_number}: Downloading from #{url}"

  begin
    # Use open-uri to fetch the content easily
    html_content = URI.open(url).read

    # Basic check to ensure content is not trivial (e.g., an error page)
    if html_content && html_content.length > 100 
      File.write(filename, html_content)
      puts "   -> Successfully saved to #{filename}"
    else
      puts "   ⚠️ Downloaded content is too short or indicates an error. Skipping write."
    end

  rescue OpenURI::HTTPError => e
    # Handle specific HTTP errors (like 404 Not Found)
    puts "   ❌ ERROR: HTTP Error for Chapter #{chapter_number} (#{e.message})."
    puts "\a"
    exit(1)
  rescue StandardError => e
    # Handle general network errors
    puts "   ❌ ERROR: Failed to download Chapter #{chapter_number}: #{e.message}"
    puts "\a"
    exit(1)
  end
  
  # Be polite: Wait a moment between requests
  sleep 0.5 
end

puts "\nProcess complete."