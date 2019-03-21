module Api
  module V1
    class FootnoteSerializer
      include FastJsonapi::ObjectSerializer

      set_type :footnote

      set_id :code

      attributes :footnote_id, :footnote_type_id, :validity_start_date, :validity_end_date

      attribute :description do |footnote|
        footnote.formatted_description
      end
    end
  end
end
