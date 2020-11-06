require "rails_helper"

describe UpdatesSynchronizerWorker, type: :worker do
  before do
    allow($stdout).to receive(:write)
    allow(TariffSynchronizer).to receive(:download)
    allow(TariffSynchronizer).to receive(:apply)
    allow(TariffSynchronizer).to receive(:download_cds)
    allow(TariffSynchronizer).to receive(:apply_cds)
  end

  describe "#perfomr" do
    context "for all envs" do
      before do
        allow(PaasConfig).to receive(:space).and_return("test")
      end

      it "invokes rollback" do
        expect(TariffSynchronizer).to receive(:download)
        expect(TariffSynchronizer).to receive(:apply)
        expect(TariffSynchronizer).not_to receive(:download_cds)
        expect(TariffSynchronizer).not_to receive(:apply_cds)
        described_class.new.perform
      end
    end

    context "for cds-test env" do
      before do
        allow(PaasConfig).to receive(:space).and_return("cds-test")
      end

      it "invokes rollback_cds" do
        expect(TariffSynchronizer).to receive(:download_cds)
        expect(TariffSynchronizer).to receive(:apply_cds)
        expect(TariffSynchronizer).not_to receive(:download)
        expect(TariffSynchronizer).not_to receive(:apply)
        described_class.new.perform
      end
    end
  end
end
