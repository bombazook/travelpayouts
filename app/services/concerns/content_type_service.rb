module ContentTypeService
  attr_reader :content_type

  def initialize(*args, content_type:, **options)
    @content_type = content_type
    super(*args, **options)
  end
end
