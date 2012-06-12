class Commodity < BaseCommodity
  # fields
  field :parent_ids,   type: Array, default: []

  # indexes
  index({ parent_ids: 1 }, { background: true })

  # tire
  # same index as headings
  index_name "commodities"

  # associations
  has_many :measures, as: :measurable
  has_many :children, class_name: 'Commodity',
                      inverse_of: :parent

  belongs_to :heading, index: true
  belongs_to :parent, class_name: 'Commodity',
                      inverse_of: :children,
                      index: true

  # callbacks
  define_model_callbacks :rearrange, only: [:before, :after]
  set_callback :save, :after, :rearrange_children, if: :rearrange_children?
  set_callback :validation, :before do
    run_callbacks(:rearrange) { rearrange }
  end

  # class methods
  def self.leaves
    where(:_id.nin => only(:parent_id).collect(&:parent_id))
  end

  def leaf?
    children.empty?
  end
  alias :leaf :leaf?

  def ancestors
    Commodity.where(:_id.in => parent_ids)
  end

  def descendants
    Commodity.where(:parent_ids => self.id)
  end

  def populate_rates
    self.update_attribute(:uk_vat_rate_cache, uk_vat_rate)
    self.update_attribute(:third_country_duty_cache, third_country_duty)
  end

  def uk_vat_rate
    measures.uk_vat.first.duty_rates if measures.uk_vat.any?
  end

  def third_country_duty
    measures.third_country.first.duty_rates if measures.third_country.any?
  end

  def parent_descriptions
    ancestors.map(&:description)
  end

  def rearrange_children!
    @rearrange_children = true
  end

  def rearrange_children?
    !!@rearrange_children
  end

  def to_param
    code
  end

  def chapter
    heading.chapter
  end

  def section
    chapter.section
  end

  def to_indexed_json
    super.merge({
      parents: parent_descriptions,
      heading: {
        id: heading.id,
        code: heading.code,
        description: heading.description,
        short_code: heading.short_code
      }
    }).to_json
  end

  private

  def rearrange
    if self.parent_id
      self.parent_ids = parent.parent_ids + [self.parent_id]
    else
      self.parent_ids = []
    end

    rearrange_children! if self.parent_ids_changed?
  end

  def rearrange_children
    @rearrange_children = false
    self.children.each { |c| c.save }
  end

  def assign_short_code
    self.short_code = code.first(10)
  end
end
