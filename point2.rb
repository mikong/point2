class Object
  
  # from Chris Wanstrath's blog: http://ozmm.org/posts/try.html
  def try(method)
    send method if respond_to? method
  end
  
end

class Array
  
  alias_method :_original_flatten, :flatten
  alias_method :_original_flatten!, :flatten!
  
  def self.try_convert(obj)
    obj.try(:to_ary)
  end
  
  def point2_flatten(level = -1)
    case
    when level < 0
      return self._original_flatten
    when level == 0
      return self
    when level > 0
      array_to_flatten = self
      new_array = []
      level.times do
        new_array.clear
        array_to_flatten.each do |element|
          if element.instance_of? Array
            element.each {|sub_elem| new_array << sub_elem }
          else
            new_array << element
          end
        end
        array_to_flatten = new_array.dup
      end
      return new_array
    end
  end
  
  def point2_flatten!(level = -1)
    self.replace(self.flatten(level))
  end
  
  alias_method :flatten, :point2_flatten
  alias_method :flatten!, :point2_flatten!
  
end

class Hash
  
  def self.try_convert(obj)
    obj.try(:to_hash)
  end
  
  # The default value in the documentation is 1, but in my local Ruby 1.9
  # it seems to be -1. I think it should match the default behavior of
  # Array#flatten, so  I'm setting it to -1 here.
  def flatten(depth = -1)
    to_a.flatten(depth)
  end
  
end

class Time

  alias_method :_original_method_missing, :method_missing
  
  def point2_method_missing(name, *args, &block)
    day_methods = [:sunday?, :monday?, :tuesday?, :wednesday?, :thursday?, :friday?, :saturday?]
    if day_methods.include? name
      return (self.wday == day_methods.index(name))
    else
      _original_method_missing(name, *args, &block)
    end
  end
  
  alias_method :method_missing, :point2_method_missing
  
end
