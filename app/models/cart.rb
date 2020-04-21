class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item_count = @contents[item.id.to_s]
    if item.merchant.discounts != []
      @thresh = item.merchant.discounts.first.threshold
    end
    # binding.pry
    # item.price * @contents[item.id.to_s] #original
    if @thresh == nil || item_count < @thresh
      item.price * item_count
    else
      reduct = item.merchant.discounts.first.percent_off
      reduct_pct = (100 - reduct.to_f)/100
      # binding.pry
      reduct_pct * item.price * item_count
    end
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def add_quantity(item_id)
    add_item(item_id)
  end

  def limit_reached?(item_id)
    @contents[item_id] == Item.find(item_id).inventory
  end

  def subtract_quantity(item_id)
    @contents[item_id] = 0 if !@contents[item_id]
    @contents[item_id] -= 1
  end

  def quantity_zero?(item_id)
    @contents[item_id] == 0
  end

end
