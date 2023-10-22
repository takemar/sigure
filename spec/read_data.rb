require 'cicphash'

def read_key(name)
  File.read(File.expand_path("data/keys/#{ name }.pem", __dir__))
end

def read_signature_base(name)
  path = File.expand_path("./data/signature_base/#{ name }.txt", __dir__)
  File.read(path).gsub(/\\\n */, '').chomp
end

def read_message(name)
  hash = CICPHash.new
  path = File.expand_path("./data/messages/#{ name }.txt", __dir__)
  File.read(path).gsub(/\\\n */, '').each_line do |line|
    name, value = line.split(':', 2)
    hash[name] = value.strip
  end
  hash
end

def read_request(name, scheme: 'http')
  hash = CICPHash.new
  path = File.expand_path("./data/requests/#{ name }.txt", __dir__)
  request = File.read(path).gsub(/\\\n */, '').lines
  method, request_target, http_version = request[0].chomp.split(' ', 3)
  hash[:@method] = method
  request[1..].each do |field_line|
    name, value = field_line.split(':', 2)
    hash[name] = value.strip
  end
  hash[:@url] = "#{ scheme }://#{ hash['Host'] }#{ request_target }"
  hash
end
