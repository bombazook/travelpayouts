module ParamsService
  attr_reader :params

  def initialize(*args, params:, **options)
    @params = params
    super(*args, **options)
  end
end
