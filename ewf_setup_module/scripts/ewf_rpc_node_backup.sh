#Part #2 - applying backup file
echo "Installing pip..." >> bootstrap-summary.txt
sudo su -
cd /
apt install python-pip -y 2>> bootstrap-summary.txt
echo "Installing gdown..." >> bootstrap-summary.txt
pip install gdown 2>> bootstrap-summary.txt
echo "Stoping parity..." >> bootstrap-summary.txt
cd ./docker-stack
docker-compose stop parity 2>> /bootstrap-summary.txt
cd ./chain-data/chains
echo "Removing current chain data..." >> /bootstrap-summary.txt
rm -rf ./${chain} 2>> /bootstrap-summary.txt
echo "Downloading latest snapshot..." >> /bootstrap-summary.txt
gdown ${backup_link} 2>> /bootstrap-summary.txt
echo "Unpacking downloaded file...." >> /bootstrap-summary.txt
tar -xvf ${backup_file}.tar 2>> /bootstrap-summary.txt
echo "Removing gzip..." >> /bootstrap-summary.txt
rm ${backup_file}.tar 2>> /bootstrap-summary.txt
echo "Starting parity...." >> /bootstrap-summary.txt
cd /docker-stack
docker-compose start parity 2>> /bootstrap-summary.txt
echo "Finished!" >> /bootstrap-summary.txt