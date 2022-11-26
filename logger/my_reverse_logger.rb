# typed: false
require 'sorbet-runtime'
require_relative '../logger/my_logger.rb'

class MyReverseLogger < MyLogger
  private

  sig { params(type: String, message: String, tag: T.nilable(String)).returns(String) }
  def create_message(type, message, tag: nil)
    output = ""
    output += "[#{tag}]" unless tag.nil?
    output += "[#{type}]"
    output += " #{message.reverse}"
    output
  end
end