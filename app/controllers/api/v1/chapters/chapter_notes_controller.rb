module Api
  module V1
    module Chapters
      class ChapterNotesController < ApiController
        before_filter :authenticate_user!

        rescue_from Sequel::RecordNotFound do |exception|
          render json: {}, status: 404
        end

        def show
          @chapter = chapter
          @chapter_note = chapter.chapter_note

          raise Sequel::RecordNotFound if @chapter_note.blank?

          respond_with @chapter_note
        end

        def create
          chapter_note = ChapterNote.new(chapter_note_params.merge(chapter_id: chapter.to_param))
          chapter_note.save(raise_on_failure: false)

          respond_with chapter_note,
            location: api_chapter_chapter_note_url(chapter)
        end

        def update
          chapter_note = chapter.chapter_note
          chapter_note.set(chapter_note_params)
          chapter_note.save(raise_on_failure: false)

          respond_with chapter_note
        end

        def destroy
          chapter_note = chapter.chapter_note

          raise Sequel::RecordNotFound if chapter_note.blank?

          chapter_note.destroy

          respond_with chapter_note
        end

        private

        def chapter_note_params
          params.require(:chapter_note).permit(:content)
        end

        def chapter
          @chapter ||= Chapter.find(goods_nomenclature_item_id: chapter_id)
        end

        def chapter_id
          sprintf("%02d00000000", params[:chapter_id] || "")
        end
      end
    end
  end
end
