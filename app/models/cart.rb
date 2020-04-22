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
    discount = find_discount(item)
    
    if discount == []
      item.price * @contents[item.id.to_s]
    else
      # binding.pry
      best_discount = discount.max_by{|k| k[:percent_off] } #returns array of discounts -- find the max :percent_off
      # reduction = discount.first.percent_off
      reduction = best_discount.percent_off
      reduction_pct = (100 - reduction.to_f)/100
      reduction_pct * item.price * @contents[item.id.to_s]
    end
  end
 
  def find_discount(item)
    item.merchant.discounts.order(threshold: :desc).map do |discount|
      if @contents[item.id.to_s] >= discount.threshold
        discount
      end
    end.compact
  end

  def best_discount(item)
    best_d = find_discount(item)
    # binding.pry
    best_d.max_by{|disc| disc[:percent_off] }
  end
  
  def total 
    @contents.sum do |item_id,quantity|
      subtotal(Item.find(item_id))
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
