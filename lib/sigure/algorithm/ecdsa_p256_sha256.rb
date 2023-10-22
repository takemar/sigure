module Sigure::Algorithm::ECDSA_P256_SHA256
  def self.verify(signature_base, key, signature)
    openssl_key = OpenSSL::PKey.read(key)
    raise unless openssl_key.group.curve_name == 'prime256v1'
    openssl_key.verify('SHA256', signature, signature_base.to_s)
  end
end
