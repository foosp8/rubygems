class Course < ApplicationRecord
  validates :title, :short_description, :language, :price, :level, presence: true
  validates :description, presence: true, length: {:minimum => 5}

  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :courses) }
  has_many :lessons, dependent: :destroy
  has_many :enrollments

  validates :title, uniqueness: true

  def to_s
    title
  end
  has_rich_text :description

  extend FriendlyId
  friendly_id :title, use: :slugged

    LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
    def self.languages
      LANGUAGES.map { |language| [language, language] }
    end

    LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]
    def self.levels
      LEVELS.map { |level| [level, level] }
      #LEVELS.map { |level| [display "1ST Level" in column, to_save DATA in "2nd level"] }
    end

    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }

    def bought(user)
     self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
    end

    def update_rating
      if enrollments.any? && enrollments.where.not(rating: nil).any?
        update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
      else
        update_column :average_rating, (0)
      end
    end

end
