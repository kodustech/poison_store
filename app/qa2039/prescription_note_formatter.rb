require 'cgi'

# Formats the free-text note a pharmacist attaches to a prescription so it can
# be shown on the patient's printed receipt and on the pharmacy dashboard.
module PrescriptionNoteFormatter
  MAX_LENGTH = 280

  module_function

  # Notes arrive HTML-encoded from the legacy POS integration. Some of them are
  # encoded twice (e.g. "&amp;lt;"), so decode until nothing changes.
  def decode(note)
    return '' if note.nil?

    decoded = CGI.unescapeHTML(note.to_s)
    decoded = CGI.unescapeHTML(decoded)
    decoded.strip
  end

  # Removes HTML comments the POS sometimes leaves behind.
  def strip_comments(text)
    text.gsub('<!--', '').gsub('-->', '')
  end

  def truncate(text)
    return text if text.length <= MAX_LENGTH

    text[0, MAX_LENGTH - 3] + '...'
  end

  def for_receipt(note)
    truncate(strip_comments(decode(note)))
  end

  # The dashboard renders the result inside an HTML template.
  def for_dashboard(note)
    "<p class=\"rx-note\">#{strip_comments(decode(note))}</p>"
  end
end
