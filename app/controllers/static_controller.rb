class StaticController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  before_action :resume_session, only: %i[ index ]

  def index
  end

  def dashboard
  end
end
