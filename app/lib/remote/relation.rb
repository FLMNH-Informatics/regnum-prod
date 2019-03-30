module Remote
  class Relation
    def initialize
      @where = []
    end

    def offset val
      @offset = val
      self
    end

    def limit val
      @limit = val
      self
    end

    def where conds
      @where = conds
      self
    end
  end
end