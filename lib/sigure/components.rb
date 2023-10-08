require 'forwardable'

class Sigure::Components

  include Enumerable
  extend Forwardable
  def_delegator :@items, :each_value, :each

  def initialize(items)
    @items = {}
    items.map do |component|
      unless component.kind_of?(Sigure::Component)
        component = Sigure::Component.new(component)
      end
      self.add(component)
    end
  end

  def add(component)
    if @items.key?(component.identifier)
      raise
    end
    @items[component.identifier] = component
  end
end
