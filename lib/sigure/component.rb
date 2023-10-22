require 'uri'
require 'addressable/uri'

class Sigure::Component < Starry::Item

  SF_FIELDS = {}

  def initialize(obj, parameters = {})
    case obj
    in Starry::Item
      super(obj.value, obj.parameters)
    in [name, p]
      super(name, p)
    in String | Symbol
      super(obj, parameters)
    else
      raise
    end

    case value
    when /\A[!#$%&'*+\-.^_`|~0-9A-Za-z]*\z/
      self.value = @name = value.to_s.downcase
      @derived_component = false
    when :@target_uri, :@request_target, :@query_param
      self.value = value.to_s.gsub('_', '-')
      @name = self.value.to_sym
      @derived_component = true
    when /\A@/
      @name = value.to_sym
      self.value = value.to_s
      @derived_component = true
    else
      raise
    end

    initialize_parameters
  end

  private def initialize_parameters
    p = parameters.transform_keys(&:to_sym).each do |k, v|
      case k
      when :sf, :bs, :req, :tr
        [k, boolean_parameter(v)]
      else
        raise unless v.kind_of?(String)
        [k, v]
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
    self.parameters = p
  end

  private def boolean_parameter(v)
    case v
    when true
      true
    when false
      nil
    else
      raise
    end
  end

  alias identifier to_s

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
    v = message[@name]
    if (parameters[:sf] || parameters[:key])
      sf_value = Starry.send("parse_#{ SF_FIELDS[@name] }", v)
      if parameters[:key]
        sf_value_for_key = sf_value[parameters[:key]]
        raise if sf_value_for_key.nil?
        v = Starry.serialize(sf_value_for_key)
      else
        v = Starry.serialize(sf_value)
      end
    end
    unless v.ascii_only?
      raise
    end
    v
  end

  private def extract_derived_value(message)
    case @name
    when :@method
      message[:@method].upcase
    when :'@target-uri'
      uri_of(message).to_s
    when :@authority
      uri_of(message).authority
    when :@scheme
      uri_of(message).scheme
    when :'@request-target'
      raise 'Not Implemented'
    when :@path
      uri_of(message).path
    when :@query
      "?#{ uri_of(message).query }"
    when :'@query-param'
      raise unless name = parameters[:name]
      query_hash = URI.decode_www_form(uri_of(message).query).map do |n, v|
        [URI.encode_www_form_component(n), URI.encode_www_form_component(v)]
      end.to_h
      raise unless query_hash.key?(name)
      query_hash[name]
    when :@status
      message[:@status].to_s
    else
      raise
    end
  end

  private def uri_of(message)
    # FIXME: Performing URI parsing on each component may be undesirable for performance
    Addressable::URI.parse((message[:@req] || message)[:@url]).normalize
  end
end
