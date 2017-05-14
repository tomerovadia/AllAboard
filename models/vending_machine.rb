require_relative 'item'

class VendingMachine

  attr_accessor :items

  def initialize(itemsFromCookie = nil)

    default_items = [
      Item.new({name: 'Doritos', price: '$0.15'}),
      Item.new({name: 'Skittles', price: '$0.20'}),
      Item.new({name: 'Cheetos', price: '$0.25'}),
      Item.new({name: 'M&Ms', price: '$0.30'}),
      Item.new({name: 'Swedish Fish', price: '$0.20'}),
      Item.new({name: 'Starburst', price: '$0.05'}),
      Item.new({name: 'Cheez-Its', price: '$0.20'})
    ]

    if itemsFromCookie
      @items = VendingMachine.importItemsFromCookie(itemsFromCookie)
    else
      @items = default_items
    end
  end


  def self.importItemsFromCookie(itemsFromCookie)

    itemsFromCookie.map do |_, item|
      Item.new({
        name: item['name'],
        price: item['price'],
        id: item['id']
      })
    end

  end



  def itemsHash
    hash = {}

    items.each { |item| hash[item.id] = item }

    hash
  end

end
