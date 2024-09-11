sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
cd /etc
sudo mkdir odoo

sudo touch /etc/odoo/odoo.conf
 sudo chmod 777 /etc/odoo/odoo.conf

 sudo     cat > /etc/odoo/odoo.conf << EOM
[options]
   ; This is the password that allows database operations:
   admin_passwd = admin
   addons_path = /mnt/extra-addons
   logfile = /var/log/odoo/odoo.log
   proxy_mode=True
workers = 5
max_cron_threads = 4
xmlrpc = True
xmlrpc_port = 8069
db_maxconn = 64
longpolling_port = 8089
limit_memory_hard = 50000000000
limit_memory_soft = 30000000000
limit_request = 10000000
limit_time_cpu = 1800000
limit_time_real = 1800000
data_dir = /var/lib/odoo
EOM
cd /opt
mkdir extra_addons
sudo chmod 777 -R /opt
sudo mkdir /data
cd /data
sudo mkdir filestore
sudo mkdir db
sudo chmod 777 -R /data
cd /var/log
sudo mkdir odoo
cd odoo
sudo touch odoo.log
sudo chmod 777 -R /var/log/odoo
docker run -d -v /data/db:/var/lib/postgresql/data -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -e POSTGRES_DB=postgres --name db postgres:15
sudo docker run -v /etc/odoo:/etc/odoo -v /opt/custom_addons:/mnt/extra-addons -v /data/filestore:/var/lib/odoo -v /var/log/odoo:/var/log/odoo -p 8069:8069 --name odoo --link db:db -t odoo