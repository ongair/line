require 'base64'
require 'openssl'

module Line
  class SignatureValidation

    def self.validate?(secret, signature, request_body)
      hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, secret, request_body)
      computed_signature = Base64.strict_encode64(hash)
      computed_signature == signature
    end

  end
end