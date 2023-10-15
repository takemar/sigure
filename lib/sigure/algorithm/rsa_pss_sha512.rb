require 'openssl'

module Sigure::Algorithm::RSA_PSS_SHA512
  def self.verify(signature_base, key, signature)
    OpenSSL::PKey.read(key).verify_pss(
      'SHA512',
      signature,
      signature_base.to_s,
      salt_length: 64,
      mgf1_hash: 'SHA512'
    )
  end
end
