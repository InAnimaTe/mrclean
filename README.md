###############
#
  Introducing....Mr. Clean! A Movie cleaner upper not made by S.C. Johnson, a family company.
#
  Made by InAnimaTe for exclusive use by kewl peoples who support the creators and buy their movies.
#
###############

How it Works:
   To visualize how this script works, you must understand the directory structure involved
   -movies
       -almostready (for releases that do not pass multiple clean tests after script finishes. They are moved here and obviously more problmatic than previously thought. (need human intervention))
       -ready (for releases that have been ripped/encoded and seem ready to go. This is the working dir for this script.)
           -Inception.2010  (the movie directory. This is the topdir (or later on cleantopdir) that holds the movie)
               -movie.mkv (the movie file)
               -movieinfo.nfo (an info file)
           -Toy.Story.2.1994

   Basically what we are doing is scanning in each movie directory, changing its name to take out bad characters, modifying the contents inside to what we want
   and then moving on to the next movie. We basically want just a single video file and a single nfo if available. We run checks on this to make sure the right number of files
   exist and are of the correct file extenion/type. We will run rarcursive to unrar any rar files and we will also make directories for loose files sitting in the ready dir(our working dir)




To install,
1) Ensure all files are sitting nicely like "/home/username/mrclean"
2) cp the example.config to /home/username/.mrclean
3) edit the config to your needs
4) run like this: ./mrclean.sh /directory/to/clean/meow

NOTE: This includes the latest version of rarcursive from March of 13. Please update from my rarcursive repo if using later than 3/13.

Requirements:
unrar
egrep
perms to the dir you are cleaning


!!! Mr. Clean only supports .mp4, .mkv, and .avi video files at this time. Feel free to suggest more supported video formats !!!

Future enhancements include cleaner code, more flexibility in defined variables and more control!

-InAnimaTe


