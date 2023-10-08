class Sigure::Component

  SF_FIELDS = {}

  def initialize(obj)
    @item = (
      case obj
      in Starry::Item
        obj
      in [name, parameters]
        Starry::Item.new(name, parameters)
      in String | Symbol
        Starry::Item.new(obj)
      else
        raise
      end
    )

    case name = @item.value
    when String
      unless name.match?(/\A[!#$%&'*+\-.^_`|~0-9A-Za-z]*\z/)
        raise
      end
      @item.value = @name = name.downcase
      @derived_component = false
    when Symbol
      @item.value = name.to_s
      @name = name
      @derived_component = true
    else
      raise
    end

    initialize_parameters
  end

  private def initialize_parameters
    p = @item.parameters.transform_keys(&:to_sym).each do |key, value|
      case key
      when :sf, :bs, :req, :tr
        [key, boolean_parameter(key, value)]
      when :key
        raise unless value.kind_of?(String)
        [key, value]
      else
        raise
      end
    end.to_h.compact
    if derived_component? && (p[:sf] || p[:key] || p[:bs] || p[:tr])
      raise
    end
    if (p[:sf] || p[:key]) && p[:bs]
      raise
    end
    if (p[:sf] || p[:key]) && !SF_FIELDS.key?(@name)
      raise
    end
    if p[:key]
      p.delete(:sf)
    end
    if p[:bs] || p[:tr]
      raise # TODO: Not implemented yet
    end
    @item.parameters = p
  end

  private def boolean_parameter(key, value)
    case value
    when true
      true
    when false
      nil
    else
      raise
    end
  end

  def identifier
    @item.to_s
  end

  def parameters
    @item.parameters
  end

  def derived_component?
    @derived_component
  end

  def extract_value_from_message(message)
    if derived_component?
      extract_derived_value(message)
    else
      extract_field_value(message)
    end
  end

  private def extract_field_value(message)
    if parameters[:req]
      message = message[:@req]
    end
    value = message[@name]
    if (parameters[:sf] || parameters[:key])
      sf_value = Starry.send("parse_#{ SF_FIELDS[@name] }", value)
      if parameters[:key]
        sf_value_for_key = sf_value[parameters[:key]]
        raise if sf_value_for_key.nil?
        value = Starry.serialize(sf_value_for_key)
      else
        value = Starry.serialize(sf_value)
      end
    end
    unless value.ascii_only?
      raise
    end
    value
  end

  private def extract_derived_value(message)
    raise 'TODO: Not implemented'
  end
end
