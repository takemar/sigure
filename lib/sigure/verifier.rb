class Sigure::Verifier

  class << self
    
    def verify(message, **options)
      self.new(message, **options).verify
    end

    def verify!(message, **options)
      self.new(message, **options).verify!
    end
  end

  def initialize(message, **options)
    @message = message
    @options = options
    @signatures = Starry.parse_dictionary(@message['signature'])
    @signature_input = Starry.parse_dictionary(@message['signature-input'])
  end

  def verify
    unless @signatures.keys.sort == @signature_input.keys.sort
      return false
    end
    @signature_input.map do |label, metadata|
      signature = @signatures[label].value
      key = resolve_key(label)
      # algorithm = determine_algorithm(label, key)
      algorithm = @options[:algorithm]
      signature_base = Sigure::SignatureBase.new(@message, metadata)
      algorithm.verify(signature_base, key, signature)
    end.compact.all?
  end

  def verify!(message)
    verify(message) || raise
  end

  def resolve_key(signature_label)
    keyid = @signature_input[signature_label].parameters['keyid']
    (@options[:key_resolver] && @options[:key_resolver][keyid]) || @options[:key] || raise
  end
end
