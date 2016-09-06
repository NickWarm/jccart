class Manager < ActiveRecord::Base
  devise :database_authenticatable
end
