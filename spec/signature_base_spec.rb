require 'cicphash'
require './lib/sigure'

RSpec.describe Sigure::SignatureBase do
  it 'handles empty field correctly' do
    message = CICPHash[{'X-Empty-Header' => ''}]
    components = ['X-Empty-Header']
    signature_base = Sigure::SignatureBase.new(message, components)
    expected = '"x-empty-header": '
    expect(signature_base.to_s.lines(chomp: true)).to include(expected)
  end
end
