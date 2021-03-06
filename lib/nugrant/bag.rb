require 'deep_merge'

module Nugrant
  class Bag
    attr_reader :__elements

    def initialize(elements = nil)
      if elements.kind_of?(Bag)
        @__elements = elements
      end

      __recompute(elements)
    end

    def [](key)
      return __fetch(key)
    end

    def method_missing(method, *args, &block)
      return __fetch(method.to_s)
    end

    def has?(key)
      return @__elements.has_key?(key)
    end

    def empty?()
      @__elements.size() <= 0
    end

    ##
    # This method always perform a deep merge but does
    # not deep merge array for now
    #
    def __merge!(elements)
      bag = elements.kind_of?(Bag) ? elements : Bag.new(elements)
      return if bag.empty?()

      bag.__each do |key, value|
        if has?(key)
          current = @__elements[key]
          if current.kind_of?(Bag) and value.kind_of?(Bag)
            current.__merge!(value)
          else
            @__elements[key] = value
          end

          next
        end

        @__elements[key] = value
      end
    end

    def __each()
      @__elements.each do |key, value|
        yield key, value
      end
    end

    def __recompute(hash = nil)
      @__elements = {}
      return if hash == nil or not hash.kind_of?(Hash)

      hash.each do |key, value|
        if not value.kind_of?(Hash)
          @__elements[key] = value
          next
        end

        # It is a hash, transform it into a bag
        @__elements[key] = Bag.new(value)
      end
    end

    def __fetch(key)
      if not has?(key)
        raise KeyError, "Undefined parameter '#{key}'"
      end

      return @__elements[key]
    end
  end
end
