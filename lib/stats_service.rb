module StatsService extend self
  def store(event:, type:)
    db.hincrby("emails-#{event}-by-type", "All", 1)
    db.hincrby("emails-#{event}-by-type", type, 1)
    db.sadd("emails-types", type)
  end

  def get(event:, type:)
    db.hget("emails-#{event}-by-type", type)
  end

  def types
    db.smembers("emails-types")
  end

  def data
    data = []
    (types + ["All"]).each do |type|
      data << [
        type,
        get(event: "send", type: type).to_i,
        get(event: "open", type: type).to_i,
        get(event: "click", type: type).to_i
      ]
    end
    data
  end

  def db
    @db ||= Redis::Namespace.new("emails-stats", :redis => Redis.new(url: "redis://127.0.0.1:6379/1"))
  end
end
