require 'spec_helper'

describe Peep do
  it 'creates new peep in the database' do
    expect { create_peep }.to change { described_class.count }.by 1
  end

  def create_peep _message = 'Today is good'
    described_class.create(message: 'Today is good')
  end
end
