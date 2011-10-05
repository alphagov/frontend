Date::DATE_FORMATS[:short_ordinal] = lambda { |date| date.strftime("%d %B %Y") }
Time::DATE_FORMATS[:short_ordinal] = lambda { |date| date.strftime("%d %B %Y") }