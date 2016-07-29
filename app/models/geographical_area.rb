class GeographicalArea < Sequel::Model
  COUNTRIES_CODES = ['0', '2'].freeze

  plugin :time_machine
  plugin :oplog, primary_key: :geographical_area_sid
  plugin :conformance_validator

  set_primary_key :geographical_area_sid

  many_to_many :geographical_area_descriptions, join_table: :geographical_area_description_periods,
                                                left_primary_key: :geographical_area_sid,
                                                left_key: :geographical_area_sid,
                                                right_key: [:geographical_area_description_period_sid,
                                                            :geographical_area_sid],
                                                right_primary_key: [:geographical_area_description_period_sid,
                                                                    :geographical_area_sid] do |ds|
    ds.with_actual(GeographicalAreaDescriptionPeriod)
      .order(Sequel.desc(:geographical_area_description_periods__validity_start_date))
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
    ds.with_actual(GeographicalAreaMembership).order(Sequel.asc(:geographical_area_id))
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
      order(Sequel.desc(:operation_date))
    end

    def countries
      where(geographical_code: COUNTRIES_CODES)
    end
  end

  delegate :description, to: :geographical_area_description

  def id
    geographical_area_id
  end
end
