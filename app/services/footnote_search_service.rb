class FootnoteSearchService
  attr_accessor :scope
  attr_reader :code, :type, :description

  def initialize(attributes)
    self.scope = Footnote
      .actual
      .eager(:footnote_descriptions)
      .eager(:goods_nomenclatures)

    @code = attributes['code']
    @type = attributes['type']
    @description = attributes['description']
  end

  def perform
    apply_code_filter if code.present?
    apply_type_filter if type.present?
    apply_description_filter if description.present?
    scope.all
  end

  private

  def apply_code_filter
    self.scope = scope
      .where("footnotes.footnote_type_id::text || footnotes.footnote_id::text LIKE '#{code}%'")
  end

  def apply_type_filter
    self.scope = scope.where(footnote_type_id: type)
  end

  def apply_description_filter
    self.scope = scope
      .join(:footnote_description_periods, [%i[footnotes__footnote_type_id footnote_description_periods__footnote_type_id], %i[footnotes__footnote_id footnote_description_periods__footnote_id]])
      .join(:footnote_descriptions, [%i[footnote_description_periods__footnote_description_period_sid footnote_descriptions__footnote_description_period_sid]])
      .with_actual(FootnoteDescriptionPeriod)
      .where(Sequel.ilike(:footnote_descriptions__description, "%#{description}%"))
  end
end
