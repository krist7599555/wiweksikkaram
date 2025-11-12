require "date"

THAI_MONTHS = {
  "ม.ค." => "Jan", "ก.พ." => "Feb", "มี.ค." => "Mar", "เม.ย." => "Apr",
  "พ.ค." => "May", "มิ.ย." => "Jun", "ก.ค." => "Jul", "ส.ค." => "Aug",
  "ก.ย." => "Sep", "ต.ค." => "Oct", "พ.ย." => "Nov", "ธ.ค." => "Dec"
}.freeze

module DateUtils
  def self.parse_thai_date(thai_date_string)
    # 1. Split the string (e.g., ["25", "มี.ค.", "68"])
    parts = thai_date_string.split
    day = parts[0].to_i
    thai_month = parts[1]
    # Assuming two-digit year is Buddhist Era (B.E. 25XX)
    thai_year_be = (parts[2].to_i + 2500) - 543

    # Convert Thai month to English short name
    english_month = THAI_MONTHS[thai_month]

    if english_month.nil?
      raise ArgumentError, "Error: Unknown Thai month abbreviation: #{thai_month}"
    end

    # Format the date string into a standard format (e.g., "25 Mar 2568")
    standard_date_string = "#{day} #{english_month} #{thai_year_be}"

    begin
      # 2. Parse the date using Date.strptime
      target_date = Date.strptime(standard_date_string, "%d %b %Y")
      target_date
      # 3. Compute the difference in days
      # The result of subtraction is a Rational number representing the day count
      # day_difference = target_date - TODAY

      # # Convert Rational to Integer for the final day count
      # day_difference.to_i

      # rescue ArgumentError => e
      #   "Error: Invalid date format or value: #{e.message}"
    end
  end
  def self.thai_date_from_now(thai_date_string)
    diff = Date.today - self.parse_thai_date(thai_date_string)
    "#{diff.to_i} วันก่อน"
  end
end
