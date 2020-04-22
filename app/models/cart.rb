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
    discount = best_discount(item)
    
    if discount == []
      item.price * @contents[item.id.to_s]
    else
      reduction_pct = (100 - discount.percent_off.to_f)/100
      item.price * @contents[item.id.to_s] * reduction_pct
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
    best_dis = find_discount(item)
    if best_dis != []
      best_dis.max_by{|discount| discount[:percent_off] } 
    else
      best_dis
    end
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
