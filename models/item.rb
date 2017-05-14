class Item
  attr_accessor :name, :price, :id

  LETTERS = ('A'..'Z').to_a

  def initialize(options)
    @id = options[:id] || LETTERS.sample + rand(100).to_s
    @name = options[:name]
    @price = options[:price]
  end

end
