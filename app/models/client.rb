# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  country    :string
#  phone      :string
#  age        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Client < ApplicationRecord
  self.primary_key = "uuid"
end
