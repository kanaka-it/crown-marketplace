require 'rails_helper'

RSpec.describe SupplyTeachers::Journey::AgencyPayrollResults, type: :model do
  subject(:results) do
    described_class.new(
      job_type: 'qt',
      term: '0_1',
      postcode: 'SW1A 1AA',
      radius: '5'
    )
  end

  it 'describes its inputs' do
    expect(results.inputs).to eq(
      looking_for: 'Individual worker',
      worker_type: 'Supplied by agency',
      payroll_provider: 'Agency',
      job_type: 'Qualified teacher: non-SEN roles',
      term: 'Up to 1 week',
      postcode: 'SW1A 1AA',
      radius: '5 miles'
    )
  end
end
