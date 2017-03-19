module Enumerable
  def reject_with_index
    arr = []
    self.each_with_index do |part, i|
      unless yield(part, i)
        arr << part
      end
    end
    arr
  end
end