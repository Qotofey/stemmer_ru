# frozen_string_literal: true

require_relative 'stemmer_ru/version'
require_relative 'stemmer_ru/patterns'

# Porter's Stemmer for Russian
class StemmerRu
  class << self
    def apply(value)
      return value.map { |word| stem(word) } if value.is_a?(Array)
      return apply(value.split) if value.match?(' ')

      stem(value)
    end

    def stem(word)
      new.send(:cut, word).downcase.sub(/ё/, 'е')
    end
  end

  private

  def cut(str)
    return str unless ONE_SYLLABLE.match?(str)

    if TWO_SYLLABLES.match?(str)
      str = cut_ending(str)
      str = str.sub(/(и)$/, '')
      str = tree_syllable(str)

      str = str.sub(SUPERLATIVE, '')
    end

    str
      .sub(/нн?$/, 'н')
      .sub(/ь?$/, '')
  end

  def cut_ending(str)
    value = str.sub(PERFECTIVEGERUND, '')
    return value if value != str

    str = str.sub(REFLEXIVE, '')
    value = str.sub(ADJECTIVE, '')

    if value != str
      str = value
      return str.sub(PARTICIPLE, '')
    end

    value = str.sub(VERB, '')
    return value if value != str

    value = str.sub(NOUN, '')
    return value if value != str

    str
  end

  def tree_syllable(str)
    return str unless THREE_SYLLABLES.match?(str)

    str.sub(/ость?$/, '')
  end
end
