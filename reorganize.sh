#!/bin/bash
# mkdir
mkdir ./+stats
mkdir ./+num
mkdir ./+datop
mkdir ./+util
# Move files to +stats
git mv ./+gen/robust_z.m ./+stats/robust_z.m
git mv ./+gen/range.m ./+stats/range.m

# Move and rename files for +num
git mv ./+gen/absargmin.m ./+num/absargmin.m
git mv ./+gen/ifbetween.m ./+num/ifbetween.m
git mv ./+gen/ifinrange.m ./+num/ifinrange.m
git mv ./+gen/ifwithin.m ./+num/ifwithin.m
git mv ./+gen/get_closest_integer_dividers.m ./+num/find_closest_integer_divisor_pair.m

# Move and rename files for +datop
git mv ./+gen/empty_like.m ./+datop/empty_like.m
git mv ./+gen/extract_numbers_from_string.m ./+datop/extract_numbers_from_string.m
git mv ./+gen/force_mergestruct.m ./+datop/hstack_struct.m
git mv ./+gen/make_column.m ./+datop/make_column.m
git mv ./+gen/make_row.m ./+datop/make_row.m
git mv ./+gen/struct_to_varargin.m ./+datop/struct_to_varargin.m
git mv ./+gen/apply_func_along_dimension.m ./+datop/apply_func_along_dimension.m

# Move file to +util
git mv ./+gen/Timer.m ./+util/Timer.m

# Delete the specified file
git rm ./+gen/combine_figures_into_subplots.m
