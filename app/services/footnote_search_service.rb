class FootnoteSearchService
  attr_accessor :scope
  attr_reader :code, :type, :description, :current_page, :per_page

  delegate :pagination_record_count, to: :scope

  def initialize(attributes, current_page, per_page)
    self.scope = Footnote
      .actual
      .eager(:footnote_descriptions)
      .eager(:goods_nomenclatures)
      .order(:footnotes__footnote_type_id, :footnotes__footnote_id)

    @code = attributes['code']
    @type = attributes['type']
    @description = attributes['description']
    @current_page = current_page
    @per_page = per_page
  end

  def perform
    apply_code_filter if code.present?
    apply_type_filter if type.present?
    apply_description_filter if description.present?
    self.scope = scope.paginate(current_page, per_page)
    scope.to_a
  end

  private

  def apply_code_filter
    self.scope = scope.where(footnotes__footnote_id: code)
  end

  def apply_type_filter
    self.scope = scope.where(footnotes__footnote_type_id: type)
  end

  def apply_description_filter
    self.scope = scope
      .join(:footnote_description_periods, [%i[footnotes__footnote_type_id footnote_description_periods__footnote_type_id], %i[footnotes__footnote_id footnote_description_periods__footnote_id]])
      .join(:footnote_descriptions, [%i[footnote_description_periods__footnote_description_period_sid footnote_descriptions__footnote_description_period_sid]])
      .with_actual(FootnoteDescriptionPeriod)
      .where(Sequel.ilike(:footnote_descriptions__description, "%#{description}%"))
  end
end
