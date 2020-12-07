class ApplicationService
  def self.call(*args)
    instance = new(*args)
    instance.call
    yield instance if block_given?
  end

  def call; end
end
