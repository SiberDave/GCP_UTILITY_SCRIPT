firewall_list_path=$(pwd)/temp_folder/gcp-firewall-list.csv
project_list_path=$(pwd)/temp_folder/list.txt
echo "starting listing firewall"

# create csv of project firewall and the open port
while read line; do
	echo "PROJECT ID : $line" >> $firewall_list_path
	echo "" >> $firewall_list_path
	echo "Name,Network, Direction, Source Ranges, Allowed Port" >> $firewall_list_path
	gcloud compute firewall-rules list --project $line --format 'csv[no-heading](name,network,direction,source_ranges,allowed[])' >> $firewall_list_path
	echo "" >> $firewall_list_path
	echo "" >> $firewall_list_path
	echo "project $line have been listed!"
done < $project_list_path

# sudo rm -rf $firewall_list_path

echo "listing firewall finished."