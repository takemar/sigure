require './lib/sigure'
require_relative 'read_data'

RSpec.describe Sigure::Verifier do
  example 'Minimal Signature Using rsa-pss-sha512' do
    result = Sigure::Verifier.verify(
      read_message('minimal-signature-using-rsa_pss_sha512'),
      key: read_key('test_key_rsa_pss_pub'),
      algorithm: Sigure::Algorithm::RSA_PSS_SHA512
    )
    expect(result).to be(true)
  end
end