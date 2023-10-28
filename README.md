# RASM4

You must demo at the beginning of class on the due date.

For this assignment, you will be creating a Menu driver program that serves as a text editor and save the resulting text to a file. You must be able to enter new strings manually and/or via a file (input.txt). All additions are additive (i.e. i can call 2b 5 x times and 5 copies of the text file would be stored in the data structure (linked list of strings). Use the enclosed file for possible input. Do not load automatically, only via the menu.

input.txtDownload input.txt

               MASM4 TEXT EDITOR
        Data Structure Heap Memory Consumption: 00000000 bytes
        Number of Nodes: 0
<1> View all strings

<2> Add string
    <a> from Keyboard
    <b> from File. Static file named input.txt

<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node).

<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed.

<5> String search. Regardless of case, return all strings that match the substring given.

<6> Save File (output.txt)

<7> Quit
 

Testing: If you read in the input file and then immediately save, the output file should be identical to the input file in every way (i.e. # of bytes).

Upload your .s file. 

s/

Prof. B.

You are going to need to install valgrind on your pi to check for  memory leaks.

https://snapcraft.io/install/valgrind/raspbianLinks to an external site.

To run your code under valgrind:

valgrind --leak-check=full ./rasm4
Test Case #1:

Option <1> View all strings
Result: [EMPTY]
Option <2><a>
Input: "Given to you during demo time"
Option <1> View all strings
[0] Given to you during demo time
Option <7>
Result: Exit the program
Test Case #2:

Option <2><b>
Option <6>
Option <7>
Result: Exit the program
console: diff -s input.txt output.txt
Result: [SAME]
Test Case #3:

Option <2><b>
Option <2><a>
Input: "Segmentation Fault"
Option <1> View all strings
Result: input file + new string from above
Option <5>Search (with_the_intention_of_deleting_one_of_those_lines)
Input a string determined by me during demo time
example: Search: tomorrow
[776] "Tomorrow is Christmas! It's practically here!"
[779] For Tomorrow, he knew, all the Who girls and boys,
[964] Ask me tomorrow but not today.
[1165] Tomorrow is another one.
Option <3> Delete
Enter the index from above
Option <1> View all strings
Result
Option <5>Search (with_the_intention_of_editing_one_of_those_lines)
Do the edit given to you and run-time (verifying that edit worked)
Option <4> Edit the line given during demo time, then display it.
Extra Credit 10 points: To allow the user to enter the filename for reading and writing.

Extra Credit 5 points: Modify your search to match Notepad++ (i.e.)

Extra Credit 10 points: Github ...

Search "toMorrow" (3 hits in 1 file of 1 searched)
    Line 777: "Tomorrow is Christmas! It's practically here!"
    Line 780: For Tomorrow, he knew, all the Who girls and boys,
    Line 1166: Tomorrow is another one.
