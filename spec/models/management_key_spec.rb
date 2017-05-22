require 'rails_helper'

RSpec.describe ManagementKey, type: :model do
  let(:space) { Space.new }

  subject(:key) do
    described_class.new(description: 'for you', space: space)
  end

  it 'has a description' do
    expect(key.description).to eq('for you')
  end

  it 'generates a uuid on save' do
    some_uuid = 'da878daf-bf82-4826-88ed-d305e9d93103'
    expect(SecureRandom).to receive(:uuid) { some_uuid }
    key.save!
    expect(key.value).to eq(some_uuid)
  end
end
