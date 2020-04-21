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

  # def subtotal(item) #sandbox solution rough
  #   if item.merchant.discounts != []
  #     @thresh = item.merchant.discounts.first.threshold
  #   end
  #   if @thresh == nil || @contents[item.id.to_s] < @thresh
  #     item.price * @contents[item.id.to_s]
  #   else
  #     reduct = item.merchant.discounts.first.percent_off
  #     reduct_pct = (100 - reduct.to_f)/100
  #     reduct_pct * item.price * @contents[item.id.to_s]
  #   end
  # end

  def subtotal(item) #refactor to find discount
    discount = find_discount(item)
    
    # if discount.compact == []
    if discount == []
      item.price * @contents[item.id.to_s]
    else
      # binding.pry
      reduction = discount.first.percent_off
      reduction_pct = (100 - reduction.to_f)/100
      reduction_pct * item.price * @contents[item.id.to_s]
    end
  end
 
  def find_discount(item) #refactor to find discount
    # binding.pry
    # item.merchant.discounts.map do |discount|
    item.merchant.discounts.order(threshold: :desc).map do |discount|
      if @contents[item.id.to_s] >= discount.threshold
        discount
      end
    end.compact
  end

  # def total #based from turing final method
  #   total = 0.0
  #   @contents.each do |item_id,quantity|
  #     # total += Item.find(item_id).price * quantity
  #     total += subtotal(Item.find(item_id))
  #   end
  #   total
  # end
  
  def total #existing brownfield
    @contents.sum do |item_id,quantity|
      # Item.find(item_id).price * quantity
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
