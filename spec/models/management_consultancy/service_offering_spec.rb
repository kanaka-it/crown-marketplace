require 'rails_helper'

module ManagementConsultancy
  RSpec.describe ServiceOffering, type: :model do
    subject(:service_offering) { build(:management_consultancy_service_offering) }

    it { is_expected.to be_valid }

    it 'is not valid if lot_number is blank' do
      service_offering.lot_number = ''
      expect(service_offering).not_to be_valid
    end

    it 'is not valid if service_code is blank' do
      service_offering.service_code = ''
      expect(service_offering).not_to be_valid
    end

    it 'can be associated with one management consultancy supplier' do
      supplier = build(:management_consultancy_supplier)
      offering = supplier.service_offerings.build
      expect(offering.supplier).to eq(supplier)
    end
  end
end