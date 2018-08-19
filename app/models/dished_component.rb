class DishedComponent < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :category, message: 'each type can not have two components with same name' }

  has_many :dish_component_associations
  has_many :dishes, -> { where(componentable: 1) }, through: :dish_component_associations

  def self.create_salad_component
    components = {
        'base' => ['Mixed green', 'Baby rocket', 'Romnaine lettuce', 'Lollo rosso', 'Iceberg lettuce', 'Batavia lettuce'],
        'dressing' => ['caesar dressing', 'thousand island', 'honey mustard', 'sweet chili', 'fine herb dressing',
                       'roasted sesame dressing', 'greek yourt dressing', 'balsamic vinaigrette'],
        'topping' => ['beetroot', 'brocoli', 'pepper', 'cherry tomato', 'cucumber', 'onion', 'mushroom', 'olive', 'baby corn', 'sweet corn', 'rady', 'carrots', 'green beans', 'baby egg', 'avocado'],
        'add_on - prime items (meat & seafood)' => ['roasted potatoes', 'fusili nature', 'penne with pesto', 'farfalle vegetable', 'tunar mayonaise', 'smoked beef', 'surimi', 'chicken chipolata', 'italian Bratwurst', 'salmon with miso', 'shrimp Italian', 'pork BBQ', 'Asia style chicken'],
        'add_on - prime items (cheese & nuts & bread)' => ['mozzarella', 'parmesan', 'feta', 'almon', 'croutons', 'sesame', 'garlic bread']
    }

    components.each do |comp|
      category = comp.first
      comp.last.each do |name|
        name = name.slice(0, 1).capitalize + name.slice(1..-1)
        DishedComponent.create name: name, category: category
      end
    end
  end
end
