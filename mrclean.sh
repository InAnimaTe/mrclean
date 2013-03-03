#!/bin/bash
# Teh directory you give mrclean will be changed into and worked out of for the entirety of the script processing. keep this in mind.
source /home/"$(id -un)"/.mrclean
cd "$1"

#   To visualize how this script works, you must understand the directory structure involved
#   -movies
#       -almostready (for releases that do not past multiple clean tests after script finishes. They are moved here and obviously more problmatic than prviously though. (need human intervention))
#       -ready (for releases that have been ripped/encoded and seem ready to go. This is the working dir for this script.)
#           -Inception.2010  (the movie directory. This is the topdir (or later on cleantopdir) that holds the movie)
#               -movie.mkv (the movie file)
#               -movieinfo.nfo (an info file)
#           -Toy.Story.2.1994
#
#   Basically what we are doing is scanning in each movie directory, changing its name to take out bad characters, modifying the contents inside to what we want
#   and then moving on to the next movie. We basically want just a single video file and a single nfo if available. We run checks on this to make sure the right number of files
#   exist and are of the correct file extenion/type. We will run rarcursive to unrar any rar files and we will also make directories for loose files sitting in the ready dir(our working dir)
#
#
#Lets check for write perms in t3h dir.
    touch testing
    if [ $? == 0 ]; then
    rm testing

#We need to run mkdir to make dirs for loose movie files...
################################################################################################
"$cur"/mkdir.sh .

#Lets begin scanning movies !!!
find . -maxdepth 1 -type d | grep -v '\.$' | sed s/^\..// | while read topdir
do
####::Start of MAIN while loop

#Lets check our perms in tis movie dir
    touch testing
    if [ $? == 0 ]; then
    rm testing

#Now lets change our topdir name to what we want it to be and then we'll work with that for the rest of the script.
cleantopdir=$(echo "$topdir" | sed 's/ /./g' | sed s/"'"//g | sed s/"&"/and/g | sed s/")"//g | sed s/"("//g | sed s/"\.-\."/\./g | sed s/","/\./g | sed s/"\]"//g | sed s/"\["//g | sed s/_/\./g | sed 's/\.\./\./g')
if [ "$topdir" != "$cleantopdir" ]; then
mv -v "$topdir" "$cleantopdir"
    else
#this is one of those things where you look back and wonder wtf you were doing. it only gets to this else if they are already equal. wow. left in for the lulz...
cleantopdir="$topdir"
fi
echo "###########################################" 
echo "########### The Movie directory has been renamed properly to $cleantopdir" 
echo "###########################################" 


#Lets do unraring!
##################################################################################################
echo "###########################################" 
echo "########### Starting Unrar process if needed." 
echo "###########################################" 
"$cur"/rarcursive.sh "$cleantopdir" delete
if [ $? == 0 ]; then

##First, find any movie file and make sure its in the topdir
#topdir=$(echo "$topdirorig" | tr -d '\n')

find "$cleantopdir" -mindepth 2 -type f | grep '.mkv$\|.avi$\|.mp4$' | while read loosefile
do
mv -v "$loosefile" "$cleantopdir"
done


##Second, delete any directory sitting alongside the movie. Should not be there.
find "$cleantopdir" -maxdepth 1 -type d | grep -v "$cleantopdir$" | while read gheydir
do
rm -rf "$gheydir"
done

##Third, lets start filtering the files by deleting anything not a movie or nfo file

find "$cleantopdir" -type f | grep -v '.mkv$\|.avi$\|.mp4$\|.nfo$\|.txt$' | while read gheyfile
do
rm -f "$gheyfile"
done

##Lets also check for sample video files. I hate those.

find "$cleantopdir" -type f | grep '.mkv$\|.avi$\|.mp4$' | grep -i sample | while read sample
do
rm -f "$sample"
done

##Fourth, lets start to filter the filenames of files still with us.

find "$cleantopdir" -type f | grep '.mkv$\|.avi$\|.mp4$\|.nfo$\|.txt$' | while read gooddirty

do
filename=$(echo "$gooddirty" | tr -d '\n' | awk -F "/" '{print $NF}')
cleanfilename=$(echo "$filename" | sed 's/ /./g' | sed s/"'"//g | sed s/"&"/and/g | sed s/")"//g | sed s/"("//g | sed s/"\.-\."/\./g | sed s/","/\./g | sed s/"\]"//g | sed s/"\["//g | sed s/_/\./g | sed 's/\.\./\./g')
#Checking if we need to change the filename
if [ "$filename" != "$cleanfilename" ]; then
    mv -v "$gooddirty" "$cleantopdir"/"$cleanfilename"
else
    cleanfilename="$filename"
fi
done

#Lets check for if there is a coexisting txt file and nfo file. if there is, we will delete the txt as nfo takes pri.
      nfo=$(ls "$cleantopdir" | grep '.nfo$')
      txt=$(ls "$cleantopdir" | grep '.txt$')
      if [ "$nfo" -a "$txt" ]; then
         rm -f "$cleantopdir"/*.txt         
      fi

#Testing for problems. If there seems to be a problem, problemo is set to 1
amount=$(ls "$cleantopdir" | wc -l)
if [ $amount -gt 2 ]; then
echo "###########################################" 
echo "########### More than 2 files residing in directory! Demoted to Almost Ready! Not Scanning." 
echo "###########################################" 

    problemo=1 

elif [ $amount == 0 ]; then
    echo "###########################################" 
    echo "########### Zero files exist in directory! Demoted to Almost Ready! Not Scanning." 
    echo "###########################################" 
    
    problemo=1

elif [ $amount == 1 ]; then
    movie=$(ls "$cleantopdir" | grep '.avi$\|.mkv$\|.mp4$')
        if [ -z movie ]; then
            echo "###########################################"           
                echo "########### Something is in the directory but it is NOT a movie! Demoted to Almost Ready! Not Scanning."   
                    echo "###########################################" 
        problemo=1
            else
        problemo=0        
        fi

elif [ $amount == 2 ]; then
   info=$(ls "$cleantopdir" | grep '.nfo$\|.txt$')
   movie=$(ls "$cleantopdir" | grep '.avi$\|.mkv$\|.mp4$')
    
    if [ -z "$info" -a -z "$movie" ]; then
            echo "###########################################"           
                echo "########### Two files exist but they are not proper! Demoted to Almost Ready! Not Scanning."   
                    echo "###########################################" 
        problemo=1
            else
        problemo=0
    fi


fi 
#Based on problemo, we will either mv the culprit or award the good release by putting it in the appropriate dir and running scanner on it.

if [ $problemo == 1 ]; then
    mv -v "$cleantopdir" "$bad"
fi
        #Heres the end of the rar check
        else
	echo "###########################################"
        echo "###### We've got a rar problem with $topdir"
	echo "###########################################"
        fi

    #Lets end our second perm check on the movie dir
    else
    echo "###########################################"
    echo "##### Where are my movie dir perms?"
    echo "###########################################"
    fi

done
    #Finishing up the first permission check
    else
    echo "###########################################"
    echo "##### Where are my permissions on this working dir?"
    echo "###########################################"
    fi
