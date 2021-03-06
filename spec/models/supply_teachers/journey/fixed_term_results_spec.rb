require 'rails_helper'

RSpec.describe SupplyTeachers::Journey::FixedTermResults, type: :model do
  subject(:results) do
    described_class.new(
      postcode: 'SW1A 1AA',
      radius: '5'
    )
  end

  it 'describes its inputs' do
    expect(results.inputs).to eq(
      looking_for: 'Individual worker',
      worker_type: 'Supplied by agency',
      payroll_provider: 'School',
      postcode: 'SW1A 1AA',
      radius: '5 miles'
    )
  end
end
