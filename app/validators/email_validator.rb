require 'mail'
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    begin
      m = Mail::Address.new(value)
      r = m.domain && m.address == value
      t = m.__send__(:tree)
      r &&= (t.domain.dot_atom_text.elements.size > 1)
    
    rescue Exception => e   
      r = false
    end
    record.errors[attribute] << (options[:message] || "is invalid") unless r
  end
end