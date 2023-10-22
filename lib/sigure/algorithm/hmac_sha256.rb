module Sigure::Algorithm::HMAC_SHA256
  def self.verify(signature_base, key, signature)
    OpenSSL.fixed_length_secure_compare(
      signature,
      OpenSSL::HMAC.digest('SHA256', key, signature_base.to_s)
    )
  end
end
