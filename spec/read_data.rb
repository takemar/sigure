require 'cicphash'

def read_key(name)
  File.read(File.expand_path("data/keys/#{ name }.pem", __dir__))
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
