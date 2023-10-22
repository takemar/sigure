module Sigure::Algorithm::RSA_V1_5_SHA256
  def self.verify(signature_base, key, signature)
    openssl_key = OpenSSL::PKey.read(key)
    raise unless openssl_key.kind_of?(OpenSSL::PKey::RSA)
    openssl_key.verify('SHA256', signature, signature_base.to_s)
  end
end
