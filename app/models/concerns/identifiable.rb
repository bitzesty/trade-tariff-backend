require 'digest'

module Models
  module Identifiable
    extend ActiveSupport::Concern

    included do
      # fields
      field :identifier,       type: String

      # callbacks
      before_validation :assign_identifier

      # indexes
      index({ identifier: 1 }, { unique: true, background: true })

      # validations
      validates :identifier, presence: true
    end

    module ClassMethods
      def identity_fields(*args)
        if args.blank?
          @_identity_fields.presence || []
        else
          @_identity_fields = args
        end
      end
    end

    def assign_identifier
      self.identifier = ""

      if self.class.identity_fields.any?
        self.class.identity_fields.each do |field|
          self.identifier << self.send(field).to_s
        end
        self.identifier = Digest::SHA1.hexdigest(self.identifier)
      end
    end
    private :assign_identifier

  end
end
