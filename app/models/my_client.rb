# == Schema Information
#
# Table name: my_clients
#
#  uuid       :string           not null, primary key
#  name       :string
#  email      :string
#  country    :string
#  phone      :string
#  age        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MyClient < ApplicationRecord
  self.primary_key = "uuid"
  has_one :address, foreign_key: "uuid"
end
