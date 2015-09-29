class Array

  def my_each(&prc)
    i = 0
    while i < self.length
      prc.call(self[i])
      i += 1
    end

    return self
  end

  def my_select(&prc)

    result = []
    my_each do |el|
      result << el if (prc.call(el))
    end

    result
  end

  def my_reject(&prc)
    result = []
    my_each do |el|
      result << el if (prc.call(el)) == false
    end

    result
  end

  def my_any?(&prc)
    my_select(&prc).length >= 1
  end

  def my_all?(&prc)
    my_reject(&prc).length <1
  end

  def my_flatten
    result = []
    my_each do |el|
      el.class == Fixnum ? result << el : result += el.my_flatten
    end
    return result
  end

  def my_zip(arr1,arr2)
    result = []
    my_each do |el|
      result << [el]
    end

    (0..self.length-1).each do |idx|
      result[idx] << arr1[idx] << arr2[idx]
    end

    return result

  end

  def my_rotate(arg = 1)
    result = []
    rotate_value = arg % self.length
    result = self[(rotate_value)...self.length] + self[0..rotate_value - 1]
  end

  def my_join(arg = "")
    result  = ""
    my_each do |el|
      result << el + arg
    end
    return result
  end

  def my_reverse
    result = []
    self.length.times do
      result << self.pop
    end
    return result
  end
end







a = [1,2,3]

p a.my_each { |el| el }
p a.my_select { |el| el > 2 }
p a.my_reject { |el| el > 2 }
p a.my_any? { |el| el > 4 }
p a.my_all? {|el| el > 0}
p [1, 2, 3, [4, [5, 6]], [[[7]], 8]].my_flatten

b = [ 4, 5, 6 ]
c = [ 7, 8, 9 ]
p a.my_zip(b, c)

a = [ "a", "b", "c", "d" ]
p a.my_rotate         #=> ["b", "c", "d", "a"]
p a.my_rotate(2)      #=> ["c", "d", "a", "b"]
p a.my_rotate(-3)     #=> ["b", "c", "d", "a"]
p a.my_rotate(15)     #=> ["d", "a", "b", "c"]
p a = [ "a", "b", "c", "d" ]
p a.my_join         # => "abcd"
p a.my_join("$")    # => "a$b$c$d"
p [ "a", "b", "c" ].my_reverse   #=> ["c", "b", "a"]
p [ 1 ].my_reverse               #=> [1]
