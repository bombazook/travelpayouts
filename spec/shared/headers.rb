RSpec.shared_context 'headers' do
  let(:content_type){ nil }
  let(:accept){ nil }
  let(:headers){ {"ACCEPT" => accept, "CONTENT-TYPE" => content_type}.select{|k,v| !v.nil?} }
end
