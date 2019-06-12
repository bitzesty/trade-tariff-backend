module Api
  module V2
    module Sections
      class SectionNotesController < ApiController
        before_action :authenticate_user!
        skip_before_action :authenticate_user!, only: [:show]

        def show
          section_note = section.section_note

          raise Sequel::RecordNotFound if section_note.blank?

          render json: Api::V2::Sections::SectionNoteSerializer.new(section_note).serializable_hash
        end

        def create
          section_note = SectionNote.new(section_note_params[:attributes].merge(section_id: section.id))

          if section_note.save(raise_on_failure: false)
            response.headers['Location'] = api_section_section_note_url(section.id)
            render json: Api::V2::Sections::SectionNoteSerializer.new(section_note).serializable_hash, status: :created
          else
            render json: Api::V2::Sections::SectionNoteSerializer.new(section_note).serialized_errors, status: :unprocessable_entity
          end
        end

        def update
          section_note = section.section_note
          section_note.set(section_note_params[:attributes])

          if section_note.save(raise_on_failure: false)
            render json: Api::V2::Sections::SectionNoteSerializer.new(section_note).serializable_hash, status: :ok
          else
            render json: Api::V2::Sections::SectionNoteSerializer.new(section_note).serialized_errors, status: :unprocessable_entity
          end
        end

        def destroy
          section_note = section.section_note

          raise Sequel::RecordNotFound if section_note.blank?

          section_note.destroy

          head :no_content
        end

        private

        def section_note_params
          params.require(:data).permit(:type, attributes: [:content])
        end

        def section
          @section ||= Section.find(id: params[:section_id])
        end
      end
    end
  end
end
