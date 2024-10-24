#! /bin/bash

ROOT_PATH=$(pwd)/temp_folder
PROJECT_ID=$1

echo "Start Listing Compute Engine on project $PROJECT_ID"

gcloud compute instances list --project $PROJECT_ID --format="csv[no-heading](name,zone,status)" > $ROOT_PATH/temp_instance_list

while read line; do
    status=$(echo $line | cut -d "," -f 3)
    if [ $status == "RUNNING" ]; then
        p_id=$(echo $line | cut -d "," -f 1)
        az=$(echo $line | cut -d "," -f 2)
        echo "$p_id,$az" >> $ROOT_PATH/temp_instance_list_1
    fi
done < $ROOT_PATH/temp_instance_list

rm -f $ROOT_PATH/temp_instance_list

echo "Finished Listing Compute Engine on project $PROJECT_ID"

echo "Start Listing Compute Engine and its private ip on project $PROJECT_ID"

if [ -f $ROOT_PATH/gcp-compute-ip-list.csv ]; then
    rm -f $ROOT_PATH/gcp-compute-ip-list.csv
fi

echo "Compute Engine Name,Private IP" > $ROOT_PATH/gcp-compute-ip-list.csv

while read line; do
    INSTANCE_NAME=$(echo $line | cut -d "," -f 1)
    AZ=$(echo $line | cut -d "," -f 2)
    gcloud compute instances describe $INSTANCE_NAME --project $PROJECT_ID --zone="$AZ" --format="csv[no-heading](name,networkInterfaces[0].networkIP)" >> $ROOT_PATH/gcp-compute-ip-list.csv
done < $ROOT_PATH/temp_instance_list_1

rm -f $ROOT_PATH/temp_instance_list_1

echo "Finished Listing Compute Engine and its private ip on project $PROJECT_ID"
