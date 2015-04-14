class Peep

  include DataMapper::Resource

  property :id, Serial # this should be just id
  property :message, String
  property :created_at, DateTime

end
