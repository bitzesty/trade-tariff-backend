class ChemicalName < Sequel::Model
  many_to_one :chemical

end
