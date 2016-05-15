class Word
  attr_accessor :word
  def initialize(attributes = {})
    @word = attributes[:word]
  end

  def  some_info
    @word = @word.reverse
    puts @word.upcase
    puts @word.downcase
    puts @word.length
    sword = @word
    puts sword.split(" ")
  end
end
