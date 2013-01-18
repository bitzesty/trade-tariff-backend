class GeographicalArea < Sequel::Model
  plugin :time_machine

  set_primary_key :geographical_area_sid

  many_to_many :geographical_area_descriptions, join_table: :geographical_area_description_periods,
                                                left_primary_key: :geographical_area_sid,
                                                left_key: :geographical_area_sid,
                                                right_key: [:geographical_area_description_period_sid,
                                                            :geographical_area_sid],
                                                right_primary_key: [:geographical_area_description_period_sid,
                                                                    :geographical_area_sid] do |ds|
    ds.with_actual(GeographicalAreaDescriptionPeriod)
      .order(:geographical_area_description_periods__validity_start_date.desc)
  end

  def geographical_area_description
    geographical_area_descriptions.first
  end

  many_to_one :parent_geographical_area, class: self
  one_to_many :children_geographical_areas, key: :parent_geographical_area_group_sid,
                                            class: self

  one_to_one :parent_geographical_area, key: :geographical_area_sid,
                                        primary_key: :parent_geographical_area_group_sid,
                                        class_name: 'GeographicalArea'

  many_to_many :contained_geographical_areas, class_name: 'GeographicalArea',
                                              join_table: :geographical_area_memberships,
                                              left_key: :geographical_area_group_sid,
                                              right_key: :geographical_area_sid,
                                              class: self do |ds|
    ds.with_actual(GeographicalAreaMembership)
  end

  one_to_many :measures, key: :geographical_area_sid,
                         primary_key: :geographical_area_sid do |ds|
    ds.with_actual(Measure)
  end

  dataset_module do
    def by_id(id)
      where(geographical_area_id: id)
    end

    def latest
      order(:created_at.desc)
    end

    def countries
      where(geographical_code: '0')
    end
  end

  delegate :description, to: :geographical_area_description

  ######### Conformance validations 250
  validates do
    # GA1
    uniqueness_of [:geographical_area_id, :validity_start_date]
    # GA2
    validity_dates
    # TODO: GA3
    # TODO: GA4
    # TODO: GA5
    # TODO: GA6
    # TODO: GA7
    # TODO: GA10
    # TODO: GA11
    # TODO: GA12
    # TODO: GA13
    # TODO: GA14
    # TODO: GA15
    # TODO: GA16
    # TODO: GA17
    # TODO: GA18
    # TODO: GA19
    # TODO: GA20
    # TODO: GA21
    # TODO: GA22
    # TODO: GA23
  end
end


