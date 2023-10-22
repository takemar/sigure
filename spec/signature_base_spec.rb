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

  it 'handles query param correctly' do
    message = CICPHash[{:@url => 'http://www.example.com/path?param=value&foo=bar&baz=batman&qux='}]
    components = [[:@query_param, {name: 'baz'}], [:@query_param, {name: 'qux'}], [:@query_param, {name: 'param'}]]
    signature_base_lines = Sigure::SignatureBase.new(message, components).to_s.lines(chomp: true)
    expected = <<~'EOS'
      "@query-param";name="baz": batman
      "@query-param";name="qux": 
      "@query-param";name="param": value
    EOS
    expected.each_line(chomp: true) do |expected_line|
      expect(signature_base_lines).to include(expected_line)
    end
  end

  xit 'handles query param with encoding process correctly' do
    message = CICPHash[{:@url => 'http://www.example.com/parameters?var=this%20is%20a%20big%0Amultiline%20value&bar=with+plus+whitespace&fa%C3%A7ade%22%3A%20=something'}]
    components = [[:@query_param, {name: 'var'}], [:@query_param, {name: 'bar'}], [:@query_param, {name: 'fa%C3%A7ade%22%3A%20'}]]
    signature_base_lines = Sigure::SignatureBase.new(message, components).to_s.lines(chomp: true)
    expected = <<~'EOS'
      "@query-param";name="var": this%20is%20a%20big%0Amultiline%20value
      "@query-param";name="bar": with%20plus%20whitespace
      "@query-param";name="fa%C3%A7ade%22%3A%20": something
    EOS
    expected.each_line(chomp: true) do |expected_line|
      expect(signature_base_lines).to include(expected_line)
    end
  end

  example 'Minimal Signature Using rsa-pss-sha512' do
    name = 'minimal-signature-using-rsa_pss_sha512'
    expcted = read_signature_base(name)
    message = read_message(name)
    signature_input = Starry.parse_dictionary(message['signature-input'])
    actual = Sigure::SignatureBase.new(message, signature_input.values[0]).to_s
    expect(actual).to eq(expcted)
  end

  example 'Selective Covered Components using rsa-pss-sha512' do
    name = 'selective-covered-components-using-rsa_pss_sha512'
    expcted = read_signature_base(name)
    message = read_request(name)
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

  example 'Signing a Response using ecdsa-p256-sha256' do
    name = 'signing-a-response-using-ecdsa_p256_sha256'
    expcted = read_signature_base(name)
    message = read_response(name)
    signature_input = Starry.parse_dictionary(message['signature-input'])
    actual = Sigure::SignatureBase.new(message, signature_input.values[0]).to_s
    expect(actual).to eq(expcted)
  end

  example 'Signing a Request using hmac-sha256' do
    name = 'signing-a-request-using-hmac_sha256'
    expcted = read_signature_base(name)
    message = read_request(name)
    signature_input = Starry.parse_dictionary(message['signature-input'])
    actual = Sigure::SignatureBase.new(message, signature_input.values[0]).to_s
    expect(actual).to eq(expcted)
  end
end
