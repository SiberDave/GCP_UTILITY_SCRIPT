#!/bin/bash
file_path=$(pwd)/temp_folder/list.txt
parent_ids=(  ) # parent id of project / folder id. (separate multiple parent id with space). Example ( 111111111111 )

if [ ! -d temp_folder ]; then
    mkdir $(pwd)/temp_folder
fi

if [ -f $file_path ]; then
    sudo rm -rf $file_path
fi

if [ ! -f $file_path ]; then
    touch $file_path
fi

echo "starting listing project"

# Process of listing all project.
for id in "${parent_ids[@]}"; do
    projects=$(gcloud projects list --filter="parent.id: $id" --format="value(projectId)")
    for project_id in $projects; do
        echo $project_id >> $file_path
    done
done

echo "listing project finished"