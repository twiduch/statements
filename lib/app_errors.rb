module AppErrors
  NotAuthorizedError = Class.new(StandardError)
  ForbiddenError = Class.new(StandardError)
end
