class SeedCladeTypes < ActiveRecord::Migration[5.2]
  def up
    clade_types.each { |clade_type| CladeType.create!(clade_type) }
  end

  def down
    # These should not be deleted in a migration
  end

  private
  def clade_types
    [
        {
            name: "Minimum Clade - Standard",
            description: "A minimum-clade definition associates a name with the smallest clade that contains two or more internal specifiers. Specifiers can be species or specimens.",
            old_value: "minimum-clade_standard"
        },
        {
            name: "Minimum Clade - Directly Specified Ancestor (rare)",
            description: "A directly-specified-ancestor definition is a special case of the minimum-clade definition in which the ancestor in which the clade originated is specified directly rather than indirectly through its descendants.",
            old_value: "minimum-clade_directly_specified_ancestor"
        },
        {
            name: "Maximum Clade - Standard",
            description: "A maximum-clade associates a name with the largest clade that contains one or more internal specifiers but does not contain one or more external specifiers.",
            old_value: "maximum-clade_standard"
        },
        {
            name: "Apomorphy Based - Standard",
            description: "An apomorphy-based definition associates a name with a clade originating in the first ancestor to evolve a specified apomorphy that was inherited by one or more internal specifiers.",
            old_value: "apomorphy-based_standard"
        },
        {
            name: "Minimum Crown Clade",
            description: "A minimum crown clade definition is a minimum clade where all of the internal specifiers are extant.",
            old_value: "minimum-crown-clade"
        },
        {
            name: "Maximum Crown Clade",
            description: "A maximum crown clade definition is a maximum clade where at least one of the internal specifiers are extant.",
            old_value: "maximum-crown-clade"
        },
        {
            name: "Apomorphy Modified Crown Clade",
            description: "An apomorphy-modified-crown clade is a minimum-clade modified by the use of an apomorphy to define the name of a crown clade.",
            old_value: "apomorphy-modified_crown_clade"
        },
        {
            name: "Maximum Total Clade",
            description: "A maximum total-clade definition is maximum clade where least one of the internal specifiers and all of the external specifiers are extant.",
            old_value: "maximum-total-clade"
        },
        {
            name: "Crown Based - Total Clade",
            description: "A crown based total clade is the total clade of a crown clade",
            old_value: "crown-based_total_clade"
        }
    ]
  end
end
