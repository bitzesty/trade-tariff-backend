class Footnote < Sequel::Model
  plugin :time_machine

  set_primary_key :footnote_id, :footnote_type_id

  one_to_one :footnote_description, key: [:footnote_id, :footnote_type_id], dataset: -> {
    FootnoteDescription.with_actual(FootnoteDescriptionPeriod)
                       .join(:footnote_description_periods, footnote_description_periods__footnote_description_period_sid: :footnote_descriptions__footnote_description_period_sid,
                                                            footnote_description_periods__footnote_type_id: :footnote_descriptions__footnote_type_id,
                                                            footnote_description_periods__footnote_id: :footnote_descriptions__footnote_id)
                       .order(:footnote_description_periods__validity_start_date.desc)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|footnote| footnote.associations[:footnote_description] = nil}

    id_map = eo[:id_map]

    FootnoteDescription.with_actual(FootnoteDescriptionPeriod)
                       .join(:footnote_description_periods, footnote_description_periods__footnote_description_period_sid: :footnote_descriptions__footnote_description_period_sid,
                                                            footnote_description_periods__footnote_type_id: :footnote_descriptions__footnote_type_id,
                                                            footnote_description_periods__footnote_id: :footnote_descriptions__footnote_id)
                       .order(:footnote_description_periods__validity_start_date.desc)
                       .where(footnote_descriptions__footnote_id: id_map.keys.map(&:first),
                              footnote_descriptions__footnote_type_id: id_map.keys.map(&:last)).all do |footnote_description|
      if footnotes = id_map[[footnote_description.footnote_id, footnote_description.footnote_type_id]]
        footnotes.each do |footnote|
          footnote.associations[:footnote_description] = footnote_description
        end
      end
    end
  end)

  delegate :description, to: :footnote_description

  ######### Conformance validations 200
  def validate
    super
    # FO1
    validates_presence :footnote_type_id
    # FO2
    validates_unique([:footnote_id, :footnote_type_id])
    # FO3
    validates_start_date
    # TODO: FO4
    # TODO: FO5
    # TODO: FO6
    # TODO: FO7
    # TODO: FO9
    # TODO: FO10
    # TODO: FO17
    # TODO: FO11
    # TODO: FO12
    # TODO: FO13
    # TODO: FO15
    # TODO: FO16
  end

  def code
    "#{footnote_type_id}#{footnote_id}"
  end

end


