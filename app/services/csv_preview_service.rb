class CsvPreviewService
  MAXIMUM_COLUMNS = 50
  MAXIMUM_ROWS = 1000

  def initialize(id:, filename:)
    @id = id
    @filename = filename
  end

  def csv_rows
    raise CSV::MalformedCSVError
    original_error = nil
    row_sep = :auto

    begin
      parsed_csv = CSV.parse(
        media_download_truncated,
        encoding: encoding(media_download_truncated),
        headers: true,
        row_sep:,
      )
    rescue CSV::MalformedCSVError => e
      if original_error.nil?
        original_error = e
        row_sep = "\r\n"
        retry
      else
        raise
      end
    end
    converted_and_restricted_csv(parsed_csv)
  end

private

  attr_reader :id, :filename

  def newline_or_last_char_index(string, newline_index)
    (0..newline_index).inject(-1) do |current_index|
      next_index = string.index("\n", current_index + 1)
      return string.length - 1 if next_index.nil?

      next_index
    end
  end

  def truncate_to_maximum_number_of_lines(string, maximum_number_of_lines)
    string[0..newline_or_last_char_index(string, maximum_number_of_lines - 1)]
  end

  def media_download_truncated
    @media_download_truncated ||= truncate_to_maximum_number_of_lines(
      GdsApi.asset_manager.media(id, filename).body,
      MAXIMUM_ROWS + 1,
    )
  end

  def encoding(media)
    @encoding ||= if utf_8_encoding?(media)
                    "UTF-8"
                  elsif windows_1252_encoding?(media)
                    "windows-1252"
                  else
                    raise FileEncodingError, "File encoding not recognised"
                  end
  end

  def utf_8_encoding?(media)
    media.force_encoding("utf-8").valid_encoding?
  end

  def windows_1252_encoding?(media)
    media.force_encoding("windows-1252").valid_encoding?
  end

  def converted_and_restricted_csv(parsed_csv)
    @converted_and_restricted_csv ||= parsed_csv.to_a.map do |row|
      row.map { |column|
        {
          text: column&.encode("UTF-8"),
        }
      }.take(MAXIMUM_COLUMNS)
    end
  end
end
