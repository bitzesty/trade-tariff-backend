class Commodity
  include Mongoid::Document
  include Mongoid::Timestamps

  include Tire::Model::Search

  # fields
  field :code,         type: String
  field :description,  type: String
  field :hier_pos,     type: Integer
  field :substring,    type: Integer
  field :synonyms,     type: String
  field :short_code,   type: String
  field :parent_ids,   type: Array, default: []
  field :uk_vat_rate_cache,         type: String
  field :third_country_duty_cache,  type: String

  # indexes
  index({ code: 1 }, { background: true })
  index({ parent_ids: 1 }, { background: true })

  # associations
  has_many :measures, as: :measurable
  has_many :children, class_name: 'Commodity',
                      inverse_of: :parent

  belongs_to :nomenclature, index: true
  belongs_to :heading, index: true
  belongs_to :parent, class_name: 'Commodity',
                      inverse_of: :children,
                      index: true

  # callbacks
  define_model_callbacks :rearrange, only: [:before, :after]
  before_save :assign_short_code
  set_callback :save, :after, :rearrange_children, if: :rearrange_children?
  set_callback :validation, :before do
    run_callbacks(:rearrange) { rearrange }
  end
  after_save :index_with_tire
  after_destroy :index_with_tire

  # tire configuration
  tire do
    mapping do
      indexes :id,                      index: :not_analyzed
      indexes :description,             analyzer: 'snowball'
      indexes :code,                    analyzer: 'simple'
      indexes :short_code,              index: :not_analyzed
      indexes :synonyms,                analyzer: 'snowball', boost: 10

      indexes :heading do
        indexes :id,                      index: :not_analyzed
        indexes :description,             analyzer: 'snowball'
        indexes :code,                    analyzer: 'simple'
        indexes :short_code,              index: :not_analyzed
      end

      indexes :chapter do
        indexes :id,                      index: :not_analyzed
        indexes :description,             analyzer: 'snowball'
        indexes :code,                    analyzer: 'simple'
        indexes :short_code,              index: :not_analyzed
      end

      indexes :section do
        indexes :id,                      index: :not_analyzed
        indexes :title,                   analyzer: 'snowball'
        indexes :numeral,                 index: :not_analyzed
        indexes :position,                index: :not_analyzed
      end
    end
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

  def to_indexed_json
    chapter = heading.chapter
    section = chapter.section

    {
      code: code,
      short_code: short_code,
      description: description,
      short_code: short_code,
      uk_vat_rate: uk_vat_rate,
      third_country_duty: third_country_duty,
      heading: {
        id: heading.id,
        code: heading.code,
        description: heading.description,
        short_code: heading.short_code
      },
      chapter: {
        id: chapter.id,
        code: chapter.code,
        description: chapter.description,
        short_code: chapter.short_code
      },
      section: {
        id: section.id,
        title: section.title,
        numeral: section.numeral,
        position: section.position
      }
    }.to_json
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

  private

  def assign_short_code
    self.short_code = code.first(10)
  end

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

  def index_with_tire
    self.tire.update_index
  end
end
