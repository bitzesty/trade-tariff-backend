module Api
  module V1
    class FootnoteSerializer
      include FastJsonapi::ObjectSerializer

      set_type :footnote

      set_id do |footnote|
        "#{footnote.footnote_type_id}#{footnote.footnote_id}"
      end

      attributes :footnote_id, :footnote_type_id, :validity_start_date, :validity_end_date

      attribute :description do |footnote|
        footnote.formatted_description
      end
    end
  end
end
