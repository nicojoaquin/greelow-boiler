#!/usr/bin/env bash

# replace $1 with $2 in file $3
replace() {
  if [[ $1 != "" && $2 != "" ]]; then
    perl -pi -e "s/$1/$2/" $3
  fi
}

function delay()
{
    sleep 0.2;
}

CURRENT_PROGRESS=0
function progress()
{
    PARAM_PROGRESS=$1;
    PARAM_PHASE=$2;

    if [ $CURRENT_PROGRESS -le 0 -a $PARAM_PROGRESS -ge 0 ]  ; then echo -ne "[..........................] (0%)  $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 5 -a $PARAM_PROGRESS -ge 5 ]  ; then echo -ne "[#.........................] (5%)  $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 10 -a $PARAM_PROGRESS -ge 10 ]; then echo -ne "[##........................] (10%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 15 -a $PARAM_PROGRESS -ge 15 ]; then echo -ne "[###.......................] (15%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 20 -a $PARAM_PROGRESS -ge 20 ]; then echo -ne "[####......................] (20%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 25 -a $PARAM_PROGRESS -ge 25 ]; then echo -ne "[#####.....................] (25%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 30 -a $PARAM_PROGRESS -ge 30 ]; then echo -ne "[######....................] (30%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 35 -a $PARAM_PROGRESS -ge 35 ]; then echo -ne "[#######...................] (35%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 40 -a $PARAM_PROGRESS -ge 40 ]; then echo -ne "[########..................] (40%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 45 -a $PARAM_PROGRESS -ge 45 ]; then echo -ne "[#########.................] (45%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 50 -a $PARAM_PROGRESS -ge 50 ]; then echo -ne "[##########................] (50%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 55 -a $PARAM_PROGRESS -ge 55 ]; then echo -ne "[###########...............] (55%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 60 -a $PARAM_PROGRESS -ge 60 ]; then echo -ne "[############..............] (60%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 65 -a $PARAM_PROGRESS -ge 65 ]; then echo -ne "[#############.............] (65%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 70 -a $PARAM_PROGRESS -ge 70 ]; then echo -ne "[###############...........] (70%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 75 -a $PARAM_PROGRESS -ge 75 ]; then echo -ne "[#################.........] (75%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 80 -a $PARAM_PROGRESS -ge 80 ]; then echo -ne "[####################......] (80%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 85 -a $PARAM_PROGRESS -ge 85 ]; then echo -ne "[#######################...] (85%) $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 90 -a $PARAM_PROGRESS -ge 90 ]; then echo -ne "[##########################] (100%) $PARAM_PHASE \r" ; delay; fi;
    if [ $CURRENT_PROGRESS -le 100 -a $PARAM_PROGRESS -ge 100 ];then echo -ne 'Done!                                            \n' ; delay; fi;

    CURRENT_PROGRESS=$PARAM_PROGRESS;

}


echo "Please, make sure you have SSH key for clonning GitHub repo." 
echo
echo "Ready? Let's get your info:"

echo
echo "Project name?"
read -r name

echo
echo "Project description?"
read -r description

echo
echo "Initializing project..."
echo
docker kill $(docker ps -q) >/dev/null 2>&1
progress 10

# echo
# echo "Cloning boiler..."
# echo
git clone git@github.com:Greelow-LLC/boiler-express-type.git $name >/dev/null 2>&1
cd $name
# echo
progress 20

# echo
# echo "Configuring files..."
progress 40

replace "greelow-boiler" "$name" "./package.json"
replace "A reusable boilerplate with Express - Typescript - typeORM for greelow projects" "$description" "./package.json"
rm init.sh
cp ./.env.example ./.env

# echo
# echo "Installing packages..."
progress 50
npm install >/dev/null 2>&1
progress 60

# echo
# echo "Running migrations..."
npm run db:start >/dev/null 2>&1
npm run db:drop >/dev/null 2>&1
npm run db:generate >/dev/null 2>&1
progress 70
migrations_file=$(find ./src/migrations/ -name 1*-migrations.ts)
SUBSTRING=$(echo $migrations_file | cut -d'-' -f 1)
FILE_NAME=$(echo $SUBSTRING | cut -d'/' -f 4)
replace "migrations$FILE_NAME" "migrations1111111111111" $migrations_file
mv $migrations_file ./src/migrations/1111111111111-migrations.ts
progress 80
npm run db:up >/dev/null 2>&1
npm run db:stop >/dev/null 2>&1
progress 90

# echo
# echo "Initializing Git..."
progress 95

rm -rf .git
git init >/dev/null 2>&1
git add . 
git commit -m 'Project Initialized'  --quiet
git branch -m develop

cd ..

progress 100
echo
echo "Project Initialized!"
echo
echo "To start your project:"
echo "cd $name"
echo "npm run db:start"
echo "npm run dev"
echo
