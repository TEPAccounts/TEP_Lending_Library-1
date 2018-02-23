class School < ApplicationRecord
    STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']].freeze
    validates_presence_of :name
    validates_presence_of :street_1
    validates_presence_of :city
    validates_presence_of :state
    validates_presence_of :zip
    validates_format_of :zip, :with => /\A\d{5}\Z/, :message => 'Zip code should be a 5 digit zip'
    validates_format_of :street_1, :with=> /\A\d+\s[A-z]+\s[A-z]+\Z/
    validates_inclusion_of :state, in: STATES_LIST.to_h.values, message: "is not an option"
    validate :no_outstanding_reservations
    validate :school_is_not_a_duplicate, on: :create
    
    
    #Relationships
    has_many :users
    has_many :reservations, through: :users

    # Callbacks
    before_destroy :destroyable
    before_save :ensure_inactive

    
    scope :alphabetical, -> { order('name') }
    scope :active, -> { where(is_active: true) }
    scope :inactive, -> { where.not(is_active: true) }
    
    
    def already_exists?
        School.where(name: self.name, zip: self.zip).size == 1
    end
    
    
    private
    def no_outstanding_reservations
        if(self.is_active == false)
            check = self.reservations.map{|r| r.returned}.inject{|r1, r2| r1 && r2}
            if(check == false)
                errors.add(:is_active, "School has outstanding reservation")
                return false
            end
        end
        return true
    end
    
    def school_is_not_a_duplicate
        return true if self.name.nil? || self.street_1.nil? || self.zip.nil?
        if self.already_exists?
          errors.add(:name, "already exists for this school at this location")
        end
      end
    
    def ensure_inactive
        if(self.is_active == false)
            self.users.each{|u| u.is_active = false
                            u.save!}
        end
    end
    
    def destroyable
        false
    end


end
