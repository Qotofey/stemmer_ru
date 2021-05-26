# frozen_string_literal: true

require_relative "stemmer_ru/version"

class StemmerRu
  class << self
    def stem(value)
      return value.map { |word| stem(word) } if value.is_a?(Array)
      return stem(value.split) if value.match?(' ')
      new.apply(value)
    end

    def apply; end
  end
end
