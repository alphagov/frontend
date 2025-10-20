class CsvPreviewService
  MAXIMUM_COLUMNS = 50
  MAXIMUM_ROWS = 1000

  class FileEncodingError < StandardError; end

  def initialize(csv)
    @csv = csv
  end

  def csv_rows
    truncated = false
    begin
      summary_csv = []
      trimmed_column_count = MAXIMUM_COLUMNS

      CSV.new(@csv, encoding: encoding(@csv), headers: false).each.with_index do |row, i|
        if i > MAXIMUM_ROWS
          truncated = true
          break
        end

        # Find the index of the last non-blank header
        if i.zero?
          trimmed_column_count = column_count_cap_from_header(row)
        end

        # Don't show columns past the last non-blank header
        if row.count > trimmed_column_count
          truncated = true
          row = row[(0...trimmed_column_count)]
        end

        # Don't preview rows that have no data
        next if row.all?(&:blank?)

        summary_csv << row.map do |column|
          {
            text: column&.encode("UTF-8"),
          }
        end
      end
    rescue Encoding::UndefinedConversionError
      raise FileEncodingError, "Character cannot be converted"
    end
    [summary_csv, truncated]
  end

private

  def column_count_cap_from_header(row)
    trimmed_row_headers = row[(0...MAXIMUM_COLUMNS)]

    row_index = trimmed_row_headers.rindex(&:present?)

    # some csvs have a blank first row, possibly followed by explanatory text
    if row_index
      [row_index + 1, MAXIMUM_COLUMNS].min
    else
      MAXIMUM_COLUMNS
    end
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
end
