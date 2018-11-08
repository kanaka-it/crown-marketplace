require 'rails_helper'

RSpec.describe Cognito::EncodedToken do
  describe '#key_id' do
    it 'returns the key id from the header of the message' do
      jwt = JSON::JWT.new({})
      jwt.header = { kid: 'key-id' }
      token = described_class.new(jwt.to_s)
      expect(token.key_id).to eq('key-id')
    end
  end

  describe '#decode' do
    it 'verifies the message signature using the key from the user pool' do
      user_pool = Cognito::UserPool.new('aws-region', 'pool-id')
      allow(user_pool).to receive(:find_key).with('key-id').and_return('key')

      token = described_class.new('encoded-token')
      allow(token).to receive(:key_id).and_return('key-id')

      allow(JSON::JWT).to receive(:decode).with('encoded-token', 'key').and_return('decoded-token')
      expect(token.decode(user_pool)).to eq('decoded-token')
    end
  end
end