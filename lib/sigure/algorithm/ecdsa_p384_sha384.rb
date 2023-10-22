module Sigure::Algorithm::ECDSA_P384_SHA384
  def self.verify(signature_base, key, signature)
    openssl_key = OpenSSL::PKey.read(key)
    raise unless openssl_key.group.curve_name == 'secp384r1'
    openssl_key.verify('SHA384', signature, signature_base.to_s)
  end
end
