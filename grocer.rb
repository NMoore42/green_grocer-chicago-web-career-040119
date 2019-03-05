def consolidate_cart(items)
	consolidated_items = {}
	items.each_with_index do |item, index|
		items[index].each do |key, value|
			if consolidated_items[key]
				consolidated_items[key][:count] += 1
			else
				consolidated_items[key] = value
				consolidated_items[key][:count] = 1
			end
		end
	end
	consolidated_items
end


def apply_coupons(cart, coupons)
  return_hash = {}
  if coupons == []
    return cart
  end
  coupons.each_with_index do |coupon, index|
    cart.each  do |item, details|
      if item == coupons[index][:item]
        if return_hash["#{item} W/COUPON"] && return_hash[item][:count] - coupons[index][:num] >= 0
          return_hash["#{item} W/COUPON"][:count] += 1
        elsif cart[item][:count] - coupons[index][:num] >= 0
          return_hash["#{item} W/COUPON"] = {:price => coupons[index][:cost], :clearance => cart[item][:clearance], :count => 1}
        end
        if return_hash[item] && return_hash[item][:count] - coupons[index][:num] >= 0
          return_hash[item][:count] -= coupons[index][:num]
        elsif cart[item][:count] - coupons[index][:num] >= 0
          return_hash[item] = {:price => cart[item][:price], :clearance => cart[item][:clearance], :count => cart[item][:count] - coupons[index][:num]}
        end
      elsif !return_hash[item]
        return_hash[item] = {:price => cart[item][:price], :clearance => cart[item][:clearance], :count => cart[item][:count]}
      end
    end
  end
  return_hash
end


def apply_clearance(cart)
  cart.each do |item, details|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    end
  end
  cart
end


def checkout(cart, coupons)
  total_price = 0
  consol_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consol_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  clearance_cart.each do |item, item_details|
    total_price += (clearance_cart[item][:price] * clearance_cart[item][:count]).round(2)
  end
  if total_price > 100
    total_price = (total_price * 0.9).round(2)
  end
  total_price
end
