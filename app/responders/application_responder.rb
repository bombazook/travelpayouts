class ApplicationResponder < ActionController::Responder
  # I'm too lazy to write separate serializers
  def to_json(*args)
    @format = :jsonapi
    to_format(*args)
  end

  # jsonapi.rb gem has separate formatter for jsonapi errors
  def display_errors
    if @format == :jsonapi
      controller.render jsonapi_errors: resource_errors, status: :unprocessable_entity
    else
      super
    end
  end

  # jsonapi docs recommend to render resource with 200 on successfull update
  def api_behavior
    raise MissingRenderer.new(format) unless has_renderer?

    if patch? || put?
      display resource, status: :ok, location: api_location
    else
      super
    end
  end

  # https://github.com/heartcombo/responders/issues/159
  def default_render
    if !get? && has_errors? && !response_overridden?
      options.merge! status: :unprocessable_entity
    end
    super
  end
end
