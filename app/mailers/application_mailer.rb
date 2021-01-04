class ApplicationMailer < ActionMailer::Base
  default from: 'support@rubygems1.herokuapp.com'
  layout 'mailer'
end
