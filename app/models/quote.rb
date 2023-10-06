class Quote < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # The HTML of the created quote should be broadcasted to users subscribed to the "quotes" stream
  # and prepended to the DOM node with the id of "quotes"

  # Equivalent to:
  # after_create_commit lambda {
  #                       broadcast_prepend_to 'quotes', partial: 'quotes/quote', locals: { quote: self },
  #                                                      target: 'quotes'
  #                     }

  # Equivalent to:
  # after_create_commit -> { broadcast_prepend_later_to "quotes" }
  # after_update_commit -> { broadcast_replace_later_to "quotes" }
  # after_destroy_commit -> { broadcast_remove_to "quotes" }

  # Those three callbacks are equivalent to the following single line
  broadcasts_to ->(_quote) { 'quotes' }, inserts_by: :prepend
end
