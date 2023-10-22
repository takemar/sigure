require 'cicphash'
require './lib/sigure'

RSpec.describe Sigure::SignatureBase do
  it 'handles empty field correctly' do
    message = CICPHash[{'X-Empty-Header' => ''}]
    components = ['X-Empty-Header']
    signature_base = Sigure::SignatureBase.new(message, components)
    expected = '"x-empty-header": '
    expect(signature_base.to_s.lines(chomp: true)).to include(expected)
  end

  example 'Minimal Signature Using rsa-pss-sha512' do
    name = 'minimal-signature-using-rsa_pss_sha512'
    expcted = read_signature_base(name)
    message = read_message(name)
    signature_input = Starry.parse_dictionary(message['signature-input'])
    actual = Sigure::SignatureBase.new(message, signature_input.values[0]).to_s
    expect(actual).to eq(expcted)
  end

  example 'Full Coverage using rsa-pss-sha512' do
    name = 'full-coverage-using-rsa_pss_sha512'
    expcted = read_signature_base(name)
    message = read_request(name)
    signature_input = Starry.parse_dictionary(message['signature-input'])
    actual = Sigure::SignatureBase.new(message, signature_input.values[0]).to_s
    expect(actual).to eq(expcted)
  end
end
