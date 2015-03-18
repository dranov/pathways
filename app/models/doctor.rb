class Doctor < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :patients, through: :teams

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
