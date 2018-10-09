require 'rails_helper'

RSpec.describe Branch, type: :model do
  subject(:branch) do
    supplier.branches.build(
      postcode: 'SW1A 1AA',
      contact_name: 'Joe Bloggs',
      contact_email: 'joe.bloggs@example.com'
    )
  end

  let(:supplier) { Supplier.create!(name: 'Supplier') }

  let(:point_factory) { RGeo::Geographic.spherical_factory(srid: 4326) }

  it { is_expected.to be_valid }

  it 'is not valid if postcode is blank' do
    branch.postcode = ''
    expect(branch).not_to be_valid
  end

  it 'is not valid if contact_name is blank' do
    branch.contact_name = ''
    expect(branch).not_to be_valid
  end

  it 'is not valid if contact_email is blank' do
    branch.contact_email = ''
    expect(branch).not_to be_valid
  end

  context 'when postcode is nonsense' do
    before do
      branch.postcode = 'nonsense'
    end

    it { is_expected.not_to be_valid }

    it 'has a sensible error message' do
      branch.validate
      expect(branch.errors).to include(postcode: include('is not a valid postcode'))
    end
  end

  context 'when three branches exist in different locations' do
    let!(:london_1) do
      supplier.branches.create!(
        postcode: 'E1 6EA',
        contact_name: 'John Smiths',
        contact_email: 'john.smith@example.com',
        location: point_factory.point(-0.0759, 51.5201)
      )
    end
    let!(:london_2) do
      supplier.branches.create!(
        postcode: 'EC1V 9HE',
        contact_name: 'Ann Jones',
        contact_email: 'ann.jones@example.com',
        location: point_factory.point(-0.0858, 51.5263)
      )
    end
    let!(:edinburgh) do
      supplier.branches.create!(
        postcode: 'EH7 4DX',
        contact_name: 'Clare Francis',
        contact_email: 'clare.francis@example.com',
        location: point_factory.point(-3.1953, 55.9619)
      )
    end

    let(:shoreditch) { point_factory.point(-0.0587, 51.5255) }

    it 'includes nearby branches' do
      expect(Branch.near(shoreditch, within_metres: 10000)).to include(london_1, london_2)
    end

    it 'excludes far away branches' do
      expect(Branch.near(shoreditch, within_metres: 10000)).not_to include(edinburgh)
    end
  end

  context 'when saving' do
    let(:westminster) { point_factory.point(-0.14189, 51.501364) }
    let(:liverpool) { point_factory.point(-2.9946932, 53.409189) }

    before do
      Geocoder::Lookup::Test.add_stub(
        'SW1A 1AA', [{ 'coordinates' => [westminster.latitude, westminster.longitude] }]
      )
      Geocoder::Lookup::Test.add_stub(
        'L3 9PP', [{ 'coordinates' => [liverpool.latitude, liverpool.longitude] }]
      )
      Geocoder::Lookup::Test.add_stub(
        'SE99 1AA', [{ 'coordinates' => nil }]
      )
    end

    it 'geocodes the initial postcode' do
      branch.save!
      expect(westminster.distance(branch.reload.location)).to be < 0.1
    end

    it 'geocodes an updated postcode' do
      branch.save!
      branch.update! postcode: 'L3 9PP'
      expect(liverpool.distance(branch.reload.location)).to be < 0.1
    end

    it 'does not geocode an initially-supplied location' do
      initial_location = point_factory.point(-3.1953, 55.9619)
      branch.location = initial_location
      branch.save!
      expect(initial_location.distance(branch.reload.location)).to be < 0.1
    end

    it 'does not geocode a postcode it cannot find' do
      branch.postcode = 'SE99 1AA'
      branch.save!
      expect(branch.reload.location).to be_nil
    end
  end
end
