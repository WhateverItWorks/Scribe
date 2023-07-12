abstract class BrowserAction < Lucky::Action
  include Lucky::ProtectFromForgery
  include Lucky::EnforceUnderscoredRoute
  include Lucky::SecureHeaders::DisableFLoC

  accepted_formats [:html, :json], default: :html
end
