class Sigure::SignatureBase

  attr_accessor :message, :components, :parameters

  def initialize(message, metadata)
    @message = message
    if metadata.kind_of?(Starry::InnerList)
      @components = Sigure::Components.new(metadata.value)
      @parameters = metadata.parameters
    else
      @components = Sigure::Components.new(metadata)
      @parameters = {}
    end
  end

  def to_s
    self.to_a.map do |k, v|
      "#{ k.to_s }: #{ v }"
    end.join("\n")
  end

  def to_a
    component_lines + [metadata_line]
  end

  private

  def component_lines
    result = components.map do |component|
      [
        component.identifier,
        component.extract_value_from_message(message)
      ]
    end
  end

  def metadata_line
    [
      '"@signature-params"',
      Starry::InnerList.new(components, parameters).to_s
    ]
  end
end
