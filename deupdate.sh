#!/bin/bash
#
################################################################
# Filename: deupdate
#
# Description: This script performs single and bulk DE-manager  
#  updates using the cdets findcr and fixcr commands. Also 
#  checks to be sure new DE-mgr is added to project users.
#
# Usage: deupdate, deupdate -b (for bulk) 
#
# Author: mfulbrig
#
# Current Maintainer: jadew
#
# Reviewer(s): ?
#
#################################################################

# Prompt user for info

echo
echo -n "Project: "
read PROJECT


# Checks for bulk update

if [ "$1" = "-b" ]; then
{
   #allows filename to be set outside of this script
   #using $PCFILE to store path to product/component file
   if [ -n "$PCFILE" ]; then
   {
      echo Product/components:
      cat $PCFILE
      echo
   }
   else
   {
      echo -n "Product/Component file: "
      read PCFILE
   }
   fi
}
else
{
   echo -n "Product: "
   read PRODUCT
   echo -n "Component: "
   read COMPONENT
   echo -n "Old DE-mgr (leave blank if none): "
   read OLDDE
}
fi

echo -n "New DE-mgr: "
read NEWDE


# Is new DE-mgr in Project Users?

VALIDDE=`cdets -p $PROJECT DE-manager | grep -w $NEWDE`


# Prompt to add new DE-mgr to Project users if not already added

while [ "$VALIDDE" != "$NEWDE" ]; do
{
   echo ""$NEWDE" has not been added to "$PROJECT" project users.  Please add via Project Administration."
   echo -n "Hit Enter when completed: "
   read
   VALIDDE=`cdets -p $PROJECT DE-manager | grep $NEWDE`
}
done


# If bulk update create component list and search  

if [ "$1" = "-b" ]; then
{
   TEMP=`cat $PCFILE | tr '\012' ' '`
   QUERY=`echo $TEMP | sed "s/$/'))/" | sed "s/ /') or ([Product] = '/g" | sed "s/\//' and [Component] = '/g" | sed "s/^/(([Product] = '/"`
   RESULTS=`findcr -s SNAOMIWHP -p $PROJECT "$QUERY and [DE-manager] <> '$NEWDE'"`

   echo "Open bugs found: "
   echo $RESULTS
}

# Single component search 

else
{
   # If old DE-mgr specified
   if [ "$OLDDE" != "" ]; then
   {
      RESULTS=`findcr -s SNAOMIWHP -p $PROJECT "[Product] = '$PRODUCT' and [Component] = '$COMPONENT' and [DE-manager] = '$OLDDE'"`
   
      echo "Open bugs found: "
      echo $RESULTS
   }

   else
   {
      RESULTS=`findcr -s SNAOMIWHP -p $PROJECT "[Product] = '$PRODUCT' and [Component] = '$COMPONENT' and [DE-manager] <> '$NEWDE'"`

      echo "Open bugs found: "
      echo $RESULTS
   }
   fi
}
fi

# If no results quit
if [ "$RESULTS" = "No records were found that matched the search criteria" ]; then
{
   exit 0
} 

# If results, update open bugs.
else
{
   echo "Updating open bugs..."
   echo $RESULTS | sed 's/ /\
/g' | fixcr -N DE-manager $NEWDE
   exit 0
}
fi
