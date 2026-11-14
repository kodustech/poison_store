require 'minitest/autorun'
require_relative 'prescription_note_formatter'

class PrescriptionNoteFormatterTest < Minitest::Test
  def test_decodes_double_encoded_notes
    assert_equal '<b>take with food</b>',
                 PrescriptionNoteFormatter.decode('&amp;lt;b&amp;gt;take with food&amp;lt;/b&amp;gt;')
  end

  def test_receipt_strips_comments
    assert_equal 'x', PrescriptionNoteFormatter.for_receipt('&lt;!--x--&gt;')
  end

  def test_truncates_long_notes
    assert_equal 280, PrescriptionNoteFormatter.for_receipt('a' * 400).length
  end
end
