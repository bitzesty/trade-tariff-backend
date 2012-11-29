class TaricImporter
  module Strategies
    class LanguageDescription < BaseStrategy
    end
    class FootnoteDescription < BaseStrategy
    end
    class RegulationRoleTypeDescription < BaseStrategy
    end
    class RegulationGroupDescription < BaseStrategy
    end
    class MeasureTypeDescription < BaseStrategy
    end
    class MeasurementUnitQualifierDescription < BaseStrategy
    end
    class Language < BaseStrategy
    end
    class TransmissionComment < BaseStrategy
    end
    class FootnoteType < BaseStrategy
    end
    class CertificateType < BaseStrategy
    end
    class AdditionalCodeType < BaseStrategy
    end
    class AdditionalCodeTypeDescription < BaseStrategy
    end
    class MeasureTypeSeries < BaseStrategy
    end
    class RegulationGroup < BaseStrategy
    end
    class RegulationRoleType < BaseStrategy
    end
    class Footnote < BaseStrategy
    end
    class FootnoteDescriptionPeriod < BaseStrategy
    end
    class Certificate < BaseStrategy
    end
    class CertificateDescriptionPeriod < BaseStrategy
    end
    class MeasurementUnit < BaseStrategy
    end
    class MeasurementUnitQualifier < BaseStrategy
    end
    class Measurement < BaseStrategy
    end
    class MonetaryUnit < BaseStrategy
    end
    class DutyExpression < BaseStrategy
    end
    class MeasureType < BaseStrategy
    end
    class AdditionalCodeTypeMeasureType < BaseStrategy
    end
    class AdditionalCode < BaseStrategy
    end
    class AdditionalCodeDescription < BaseStrategy
    end
    class AdditionalCodeDescriptionPeriod < BaseStrategy
    end
    class FootnoteAssociationAdditionalCode < BaseStrategy
    end
    class GeographicalArea < BaseStrategy
    end
    class GeographicalAreaDescriptionPeriod < BaseStrategy
    end
    class GeographicalAreaMembership < BaseStrategy
    end
    class GoodsNomenclatureGroup < BaseStrategy
    end
    class CompleteAbrogationRegulation < BaseStrategy
    end
    class ExplicitAbrogationRegulation < BaseStrategy
    end
    class BaseRegulation < BaseStrategy
    end
    class ModificationRegulation < BaseStrategy
    end
    class ProrogationRegulation < BaseStrategy
    end
    class ProrogationRegulationAction < BaseStrategy
    end
    class FullTemporaryStopRegulation < BaseStrategy
    end
    class FtsRegulationAction < BaseStrategy
    end
    class RegulationReplacement < BaseStrategy
    end
    class MeursingTablePlan < BaseStrategy
    end
    class MeursingHeading < BaseStrategy
    end
    class FootnoteAssociationMeursingHeading < BaseStrategy
    end
    class MeursingSubheading < BaseStrategy
    end
    class MeursingAdditionalCode < BaseStrategy
    end
    class MeursingTableCellComponent < BaseStrategy
    end
    class MeasureConditionCode < BaseStrategy
    end
    class MeasureAction < BaseStrategy
    end
    class QuotaOrderNumber < BaseStrategy
    end
    class QuotaOrderNumberOrigin < BaseStrategy
    end
    class QuotaOrderNumberOriginExclusion < BaseStrategy
    end
    class QuotaDefinition < BaseStrategy
    end
    class QuotaBlockingPeriod < BaseStrategy
    end
    class QuotaSuspensionPeriod < BaseStrategy
    end
    class QuotaAssociation < BaseStrategy
    end
    class QuotaBalanceEvent < BaseStrategy
    end
    class QuotaUnblockingEvent < BaseStrategy
    end
    class QuotaCriticalEvent < BaseStrategy
    end
    class QuotaExhaustionEvent < BaseStrategy
    end
    class QuotaReopeningEvent < BaseStrategy
    end
    class QuotaUnsuspensionEvent < BaseStrategy
    end
    class GoodsNomenclature < BaseStrategy
      # NOTE Taric update on GoodsNomenclature may result in associated national measures
      # becoming invalid as a result of ME8 conformance validation.
      # Therefore we do a soft delete by setting invalidated columns. No further
      # validations will be performed on such measures. They won't be provided
      # via API either.
      process(:update) {
        goods_nomenclature = klass.filter(self.attributes.slice(*primary_key).symbolize_keys).first
        goods_nomenclature.update(self.attributes.except(*primary_key).symbolize_keys)
        goods_nomenclature.measures_dataset.national.non_invalidated.each do |measure|
          unless measure.valid?
            measure.update invalidated_by: transaction_id,
                           invalidated_at: Time.now
          end
        end
      }
    end
    class GoodsNomenclatureIndent < BaseStrategy
    end
    class GoodsNomenclatureDescriptionPeriod < BaseStrategy
    end
    class GoodsNomenclatureOrigin < BaseStrategy
    end
    class GoodsNomenclatureSuccessor < BaseStrategy
    end
    class FootnoteAssociationGoodsNomenclature < BaseStrategy
    end
    class NomenclatureGroupMembership < BaseStrategy
    end
    class ExportRefundNomenclature < BaseStrategy
    end
    class ExportRefundNomenclatureIndent < BaseStrategy
    end
    class ExportRefundNomenclatureDescriptionPeriod < BaseStrategy
    end
    class FootnoteAssociationErn < BaseStrategy
    end
    class Measure < BaseStrategy
    end
    class MeasureComponent < BaseStrategy
    end
    class FootnoteAssociationMeasure < BaseStrategy
    end
    class MeasureExcludedGeographicalArea < BaseStrategy
    end
    class MeasureCondition < BaseStrategy
    end
    class MeasureConditionComponent < BaseStrategy
    end
    class MeasurePartialTemporaryStop < BaseStrategy
    end
    class MonetaryExchangePeriod < BaseStrategy
    end
    class MonetaryExchangeRate < BaseStrategy
    end
    class DutyExpressionDescription < BaseStrategy
    end
    class MeasureTypeSeriesDescription < BaseStrategy
    end
    class CertificateTypeDescription < BaseStrategy
    end
    class FootnoteTypeDescription < BaseStrategy
    end
    class CertificateDescription < BaseStrategy
    end
    class GoodsNomenclatureDescription < BaseStrategy
    end
    class MonetaryUnitDescription < BaseStrategy
    end
    class MeasurementUnitDescription < BaseStrategy
    end
    class MeasureActionDescription < BaseStrategy
    end
    class GoodsNomenclatureGroupDescription < BaseStrategy
    end
    class MeasureConditionCodeDescription < BaseStrategy
    end
    class MeursingHeadingText < BaseStrategy
    end
    class GeographicalAreaDescription < BaseStrategy
    end
    class ExportRefundNomenclatureDescription < BaseStrategy
    end
  end
end
