class Search

  TYPES = %w(all questions answers comments users)

  class << self
    def execute(query, type)
      if type == 'all'
        ThinkingSphinx.search(escape(query))
      else
        klass(type).search(escape(query)) if TYPES.include?(type)
      end
    end

    def klass(string)
      string.classify.constantize
    end

    def escape(query)
      ThinkingSphinx::Query.escape(query)
    end
  end
end