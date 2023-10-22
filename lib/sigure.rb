require 'openssl'
require 'starry'

module Sigure
  module Algorithm; end
end

require_relative 'sigure/algorithm/rsa_pss_sha512'
require_relative 'sigure/algorithm/rsa_v1_5_sha256'
require_relative 'sigure/algorithm/hmac_sha256'
require_relative 'sigure/algorithm/ecdsa_p256_sha256'
require_relative 'sigure/algorithm/ecdsa_p384_sha384'
require_relative 'sigure/component'
require_relative 'sigure/components'
require_relative 'sigure/signature_base'
require_relative 'sigure/verifier'

require_relative 'sigure/version'
