class CommodityMapper
  module MappedCommodity
    attr_accessor :parent
    attr_writer :ancestors

    def children
      @children ||= []
    end

    def leaf?
      children.empty?
    end
    alias :leaf :leaf?

    def ancestors
      @ancestors ||= []
    end
  end

  # speed up the lookup without doing mongo queries
  attr_reader :parent_map

  def initialize(commodities)
    @commodities = commodities.map { |commodity| commodity.extend(MappedCommodity) }
    @parent_map = {}

    process
  end

  def all
    @commodities.reject { |commodity| commodity.parent.present? }
  end
  alias :commodities :all

  def find
    @commodities.detect { |c| yield(c) } if block_given?
  end
  alias :detect :find

  def for_commodity(ref_commodity)
    detect{|commodity| commodity.goods_nomenclature_sid == ref_commodity.goods_nomenclature_sid }
  end

  def process
    # first pair
    traverse(commodities, nil, commodities.first)
    # all other pairs
    traverse(commodities, commodities.first, commodities.second)
  end

  private

  def traverse(commodities, primary, secondary)
    # ignore case when first commodity is blank it's a direct child of the heading
    unless commodities.index(secondary).blank?
      next_commodity = commodities[commodities.index(secondary) + 1]
      if next_commodity.present? # we are not at the end of the commodity array
        map_commodities(secondary, next_commodity)
        traverse(commodities, secondary, next_commodity)
      end
    end
  end

  def map_commodities(primary, secondary)
    if primary.number_indents < secondary.number_indents
      primary.children << secondary unless primary.children.include?(secondary)

      parent_map[secondary.id] = primary
      secondary.parent = primary
      secondary.ancestors += primary.ancestors
      secondary.ancestors << primary
    elsif primary.number_indents == secondary.number_indents
      if primary.parent.present? # if primary is not directly under heading
        primary.parent.children << secondary unless primary.parent.children.include?(secondary)

        parent_map[secondary.id] = primary.parent
        secondary.parent = primary
        secondary.ancestors += primary.ancestors
        secondary.ancestors << primary
      end
    else primary.number_indents > secondary.number_indents
      parent = nth_parent(primary, secondary.number_indents)

      if parent.present?
        parent.children << secondary unless parent.children.include?(secondary)

        parent_map[secondary.id] = parent
        secondary.parent = parent
        secondary.ancestors += parent.ancestors
        secondary.ancestors << parent
      end
    end
  end

  def nth_parent(commodity, nth)
    if nth > 0
      commodity = commodity.parent

      while commodity.present? && commodity.number_indents >= nth
        commodity = parent_of(commodity)
      end

      commodity
    end
  end

  def parent_of(commodity)
    parent_map[commodity.id]
  end
end
