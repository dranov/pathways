class TreatmentState < ActiveRecord::Base
  belongs_to :pathway
  has_many :treatment_modules
  validates :timeframe, inclusion: { in: %w(future present past) }

  # for patient hub
  def self.for_category(category)
    TreatmentStates.joins(treatment_modules: { data_modules: { subcategory: :category}}).where(category: { id: category })
  end

  def has_module(dm)
    !DataModule.joins(treatment_modules: :treatment_state).where(id: dm.id, treatment_states: {id: self.id }).blank?
  end

  def has_module_with_id(id)
    !DataModule.joins(treatment_modules: :treatment_state).where(id: id, treatment_states: {id: self.id }).blank?
  end

  def categories
    @categories = []
    treatment_modules.each {|i| @categories << i.data_module.subcategory.category}
    @categories.uniq
  end

  def subcategories(category)
    @subcategories = []
    treatment_modules.each do |i|

      if i.data_module.subcategory.category == category
        @subcategories << i.data_module.subcategory
      end

    end
    @subcategories.uniq
  end

  def data_per_subcategory(category)
    @result = {}
    @subcategories = subcategories(category)
    @subcategories.each do |i|
      @data_modules = []

      treatment_modules.each do |f|
        if f.data_module.subcategory == i && f.data_module.subcategory.category == category
          @data_modules << f.data_module
        end
      end

      @result[i.name] = @data_modules
    end
    @result
  end
end
