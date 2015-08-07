class MentionFilters::MessageMentionFilter < MentionFilters::MentionFilter

  def pattern
    /
      (?:^|\W)                   # beginning of string or non-word char
      \?((?>[1-9][0-9]*)-(?>[1-9][0-9]*))             # ?channel_sequential_id-message_floor
      (?!\/)                     # without a trailing slash
      (?=
        \.+[ \t\W]|              # dots followed by space or non-word character
        \.+$|                    # dots at end of line
        [^0-9a-zA-Z_.]|          # non-word character except dot
        $                        # end of line
      )
    /ix
  end

  def mention_character
    '?'
  end

end
