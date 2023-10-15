require 'starry'

module Sigure
  module Algorithm; end
end

require_relative 'sigure/algorithm/rsa_pss_sha512'
require_relative 'sigure/component'
require_relative 'sigure/components'
require_relative 'sigure/signature_base'
require_relative 'sigure/verifier'

require_relative 'sigure/version'
