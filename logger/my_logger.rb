# typed: false
require 'sorbet-runtime'

class MyLogger
  extend T::Sig

  def initialize(warn_size: nil, error_size: nil)
    @warn_size = warn_size
    @error_size = error_size
    init_buffer
  end

  sig { params(message: String, tag: String).returns(String) }
  def info(message, tag: nil)
    create_message("INFO", message, tag: tag)
  end

  sig { params(message: String, tag: String).returns(T.nilable(T.nilable(String))) }
  def warn(message, tag: nil)
    message = create_message("WARN", message, tag: tag)
    unless @warn_size.nil?
      output = nil
      enque_warn_message(message)
      decrement_warn
      output = show_warn_buffer if @warn_size_aux.zero?
      output
    else
      message
    end
  end

  sig { params(message: String, tag: String).returns(T.nilable(T.nilable(String))) }
  def error(message, tag: nil)
    message = create_message("ERROR", message, tag: tag)
    unless @error_size.nil?
      output = nil
      enque_error_message(message)
      decrement_error
      output = show_error_buffer if @error_size_aux.zero?
      output
    else
      message
    end
  end

  private

  sig { params(type: String, message: String, tag: T.nilable(String)).returns(String) }
  def create_message(type, message, tag: nil)
    output = ""
    output += "[#{tag}]" unless tag.nil?
    output += "[#{type}]"
    output += " #{message}"
    output
  end

  def init_buffer
    @warn_size_aux = @warn_size
    @error_size_aux = @error_size
    @warn_messages = []
    @error_messages = []
  end

  def show_warn_buffer
    messages = show_messages(@warn_messages)
    @warn_messages = []
    @warn_size_aux = @warn_size
    messages
  end

  def enque_warn_message(message)
    @warn_messages << message
  end

  def show_error_buffer
    messages = show_messages(@error_messages)
    @error_messages = []
    @error_size_aux = @error_size
    messages
  end

  def show_messages(data)
    message_output = ""
    data.each do |message|
      unless message.equal? data.last
        message_output += message + "/n"
      else
        message_output += message
      end
    end
    message_output
  end

  def enque_error_message(message)
    @error_messages << message
  end

  def decrement_warn
    @warn_size_aux -= 1
  end

  def decrement_error
    @error_size_aux -= 1
  end
end