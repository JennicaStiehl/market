class Market
  attr_reader   :name,
                :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.keys.include?(item)
    end
  end

  def sorted_item_list
    sorted = []
    @vendors.each do |vendor|
      vendor.inventory.keys.map do |item|
        sorted << item
      end
    end
    sorted.uniq.sort
  end

  def total_inventory
    total = Hash.new(0)
    total_amount = 0
    @vendors.each do |vendor|
      vendor.inventory.each do |item, amount|
        if total.keys.include?(item)
          total_amount += amount
          total[item] += total_amount
        elsif !total.keys.include?(item)
          total[item] = amount
        end
      end
    end
    total
    #----------------------------------------#
    # new_amount = 0
    # @vendors.each do |vendor|
    #   vendor.inventory.each do |item, amount|
    #     if vendor.check_stock(item) >= 0
    #       new_amount = amount += vendor.check_stock(item)
    #       total[item] = new_amount
    #     else
    #       total[item] = amount
    #     end
    #   end
    # end
    # total
  end

  def sell(item, amount)
    answer = false
    vendors = vendors_that_sell(item)
    vendors_that_sell(item).each_with_index do |vendor, i|
      if vendor.inventory[item] >= amount && vendors[i +1].check_stock(item) > 0
        vendor.inventory[item] -= amount
        binding.pry
        first_vendor = vendor.inventory.values_at(item)
        remaining = amount - first_vendor[0]
        if vendor.inventory[item] <= 0 && remaining < 0
          @vendors[i + 1].inventory[item] -= remaining
        end
        answer = true
      elsif vendor.inventory[item] <= amount && vendors[i +1].check_stock(item) > 0
        @vendors[i +1].inventory[item] -= amount
        answer = true
      else
        answer = false
      end
      answer
    end
    answer
  end

end
