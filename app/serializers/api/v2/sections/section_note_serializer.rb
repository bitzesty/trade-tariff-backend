module Api
  module V2
    module Sections
      class SectionNoteSerializer
        include FastJsonapi::ObjectSerializer

        set_type :section_note

        set_id :id

        attributes :section_id, :content

        def serialized_errors
          errors = @resource.errors.flat_map do |attribute, error|
            { title: attribute, detail: error }
          end

          { errors: errors }
        end
      end
    end
  end
end
