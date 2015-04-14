require 'spec_helper'

describe User do
  it 'creates new user in the database' do
    expect { create_user }.to change { described_class.count }.by 1
  end

  it "doesn't let you create two of the same username" do
    described_class.create(username: 'saramoohead', name: 'Sara OC', email: 'somethingelse@hotmail.com')
    expect(create_user.errors.full_messages).to eq ["Sorry, that username is already taken."]
  end

  def create_user _name = 'Sara OC', _email = 'saramoo@hotmail.com', _username = 'saramoohead'
    described_class.create(username: 'saramoohead', name: 'Sara OC', email: 'saramoo@hotmail.com')
  end
end
