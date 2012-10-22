class EmailFormatValidator < ActiveModel::EachValidator

  VALID_EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,4})$/i

  def validate_each(object, attribute, value)
    unless value =~ VALID_EMAIL_REGEX 
      object.errors[attribute] << (options[:message] || "is not formatted properly")
    end
  end
end
