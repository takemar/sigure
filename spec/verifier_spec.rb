require 'base64'
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

  example 'Selective Covered Components using rsa-pss-sha512' do
    result = Sigure::Verifier.verify(
      read_request('selective-covered-components-using-rsa_pss_sha512'),
      key: read_key('test_key_rsa_pss_pub'),
      algorithm: Sigure::Algorithm::RSA_PSS_SHA512
    )
    expect(result).to be(true)
  end

  example 'Full Coverage using rsa-pss-sha512' do
    result = Sigure::Verifier.verify(
      read_request('full-coverage-using-rsa_pss_sha512'),
      key: read_key('test_key_rsa_pss_pub'),
      algorithm: Sigure::Algorithm::RSA_PSS_SHA512
    )
    expect(result).to be(true)
  end

  example 'Signing a Response using ecdsa-p256-sha256' do
    result = Sigure::Verifier.verify(
      read_response('signing-a-response-using-ecdsa_p256_sha256'),
      key: read_key('test_key_ecc_p256_pub'),
      algorithm: Sigure::Algorithm::ECDSA_P256_SHA256
    )
    expect(result).to be(true)
  end

  example 'Signing a Request using hmac-sha256' do
    result = Sigure::Verifier.verify(
      read_request('signing-a-request-using-hmac_sha256'),
      key: Base64.decode64(File.read(File.expand_path("data/keys/test_shared_secret.txt", __dir__))),
      algorithm: Sigure::Algorithm::HMAC_SHA256
    )
    expect(result).to be(true)
  end
end
