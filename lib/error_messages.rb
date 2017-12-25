# frozen_string_literal: true

module ErrorMessages
  FILE_HELPER_ERRORS = {
    digesting_error: 'Digesting filepath failed for',
    deleting_error: 'Deleting file failed for'
  }.freeze

  ERROR_MESSAGES = FILE_HELPER_ERRORS

  def join(*args)
    args.join(' ')
  end
end
