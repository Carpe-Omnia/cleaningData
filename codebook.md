The run_analysis.R file I created does the following:
retrives the motion dataset (if it doesn't already exist in the local directory)
creates strings containing the relative paths to everything needed
unzips the downloaded file if those things are not already pre-existing
Loads into memory the training/test X, Y, and Subjects; as well as the features and activity labels
combines the corresponding Xs Ys and Subjects to create fuller data tables
Uses the activity labels dataset to comb through the combined Y data and replace activity numbers with clear labels
-this step is important because it pre-accomplishes part 3 of the assignment
Combines all 3 data elements into one table, 
-thereby accomplishing step 1
Removes all columns from the combined dataset not pertaining to means and standard deviations
-accomplishes step 2
Renames a few columns to clarify their meaning
-accomplishes step 4
Writes the refined data to a file called tidyData.txt
Produces summary data writes it to a file called summaryData.txt
-accomplishes step 5
