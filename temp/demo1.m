%% Example Usage
arr1 = rand(2, 3, 4);
arr2 = rand(2, 3, 2);
arr3 = rand(2, 3, 5);
arr4 = logical(randi([0 1], 2, 3, 3));

prj = gen.ProjectedArray(arr1, arr2, arr3, arr4);

% Accessing the concatenated array
disp(prj.A);

%%

% Accessing individual arrays
retrieved_arr1 = prj(1);
disp(isequal(retrieved_arr1, arr1)); % Should be true

retrieved_arr3 = prj(3);
disp(isequal(retrieved_arr3, arr3)); % Should be true

% Accessing elements within an array
element = prj(1, 1, 2, 3);  % Equivalent to arr1(1, 2, 3)
disp(element);
disp(arr1(1,2,3));

subset = prj(2, :, 1:2, :); % Equivalent to arr2(:, 1:2, :)
disp(subset);
disp(isequal(subset,arr2(:,1:2,:)));

% Test error handling
try
    prj(5);  % Invalid index
catch ME
    disp(ME.message);
end

try
    prj(1, 4, 4, 4);  % Invalid sub-indices for arr1
catch ME
    disp(ME.message);
end

try
   prj{1};
catch ME
  disp(ME.message)
end

% Display the ProjectedArray object
disp(prj);

%Test different sized arrays
arr5 = rand(5,5,5);
arr6 = rand(5,5,1);
arr7 = ones(5,5,2);

prj2 = ProjectedArray(arr5,arr6, arr7);
disp(prj2)
disp(prj2.A)
test = prj2(1,1,1,:);
disp(test)
test_ans = squeeze(arr5(1,1,:));
disp(test_ans);
disp(isequal(test,test_ans));

test2 = prj2(3,:,:,2);
disp(test2);
test_ans2 = squeeze(arr7(:,:,2));
disp(test_ans2);
disp(isequal(test2, test_ans2));

% Test with a logical array
arr8 = true(2,2,2);
arr9 = false(2,2,1);
prj3 = ProjectedArray(arr8, arr9);
disp(prj3.A);
disp(prj3(1));
disp(prj3(2));
disp(prj3(1,:,:,1));
%%

% Create some ProjectedArray objects
arr1 = rand(2, 3, 4);
arr2 = rand(2, 3, 2);
arr3 = rand(2, 3, 5);
prj1 = gen.ProjectedArray(arr1, arr2);
prj2 = gen.ProjectedArray(arr2, arr3);
prj3 = gen.ProjectedArray(arr1, arr3);
arr4 = rand(2,3,1);
% prj4 = gen.ProjectedArray(arr1,arr2,arr3,arr4);

% Create a MetaProjectedArray from individual ProjectedArrays (1x3)
meta_prj1 = gen.MetaProjectedArray(prj1, prj2, prj3);
disp(meta_prj1);

%%
% Access a specific ProjectedArray
retrieved_prj = meta_prj1(1, 2);  % Get prj2
disp(retrieved_prj);
disp(isequal(retrieved_prj, prj2));

% Chained indexing
element = meta_prj1(1, 1, 2, 1, 2); % Equivalent to prj1(2, 1, 2) which is arr2(1,2)
disp(element);
disp(arr2(1,2));

% Create a MetaProjectedArray from a cell array (2x2)
cell_array = {prj1, prj2; prj3, prj4};
meta_prj2 = MetaProjectedArray(cell_array);
disp(meta_prj2);

% Accessing elements in the 2x2 MetaProjectedArray
retrieved_prj2 = meta_prj2(2, 1); % Get prj3
disp(retrieved_prj2);

element2 = meta_prj2(2, 2, 1, 1, 1, 1); % prj4(1, 1, 1, 1) which is arr1(1,1,1)
disp(element2);

% Error handling
try
    meta_prj1(2, 2);  % Invalid index
catch ME
    disp(ME.message);
end

try
  meta_prj1(1,1,1, 5,5,5,5,5); %too many indices
catch ME
  disp(ME.message)
end