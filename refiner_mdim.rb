#!/usr/bin/ruby

# apply a dim array onto an entity's tag array
# so that every entity can be counted / measured 
# in this dim-space
module MultiDimDataRefine
  class DataRefiner
    def initialize
      #
    end
    def build_dim_array(entity_tag_arrs)
      dim_arr = []
      entity_tag_arrs.each do |tag_arr|
        dim_arr = (dim_arr + tag_arr.sort.uniq).sort.uniq
      end
      return dim_arr
    end
    def apply_dim_array(dim_arr, entity_tag_arr)
      a1 = dim_arr.clone          # copy dim_arr, so the original data 
                                  # won't be changed
      a2 = entity_tag_arr.clone   # same as above
      a1.each do |ea1|             # pick a dimension from the array
        if a2 == []                # if the tag array is already empty
          a1[a1.index(ea1)] = ''   # then the rest dimensions will be useless
        end
        a2.each do |ea2|     # pick a tag from the tag array for comparison
          if (ea1 == ea2)    # if the dimension name is equal to the tag name
            a2.delete(ea1)   # this dimension will be kept, 
                             # remove the tag from tag array 
                             # since it's already been processed
            break   # have to break at here because
                    # a certain dimension will only be applied once 
                    # moreover, the rest tags in the tag array will
                    # all be different from this certain dimension
          else
            if a1.index(ea1) != nil
              a1[a1.index(ea1)] = ''
            end
          end
        end
      end
      return a1
    end
    # a usage demo
    def how_to_demo
      a1 = (["1","2","3"]+["b","c","a","c"]).sort.uniq
      a2 = ["a","c"].sort.uniq
      a3 = ["2","3","b"].sort.uniq

      print a1, "\n"
      print a2, "\n"
      print a3, "\n"

      print apply_dim_array(a1, a2), "\n"
      print apply_dim_array(a1, a3), "\n"
    end
  end
end

