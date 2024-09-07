sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install openssh-server fail2ban -y
sudo apt-get install -y python3-pip
sudo apt-get install python-dev python3-dev libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev libldap2-dev build-essential libssl-dev libffi-dev libmysqlclient-dev libjpeg-dev libpq-dev libjpeg8-dev liblcms2-dev libblas-dev libatlas-base-dev -y
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less less-plugin-clean-css
sudo apt-get install -y node-less
sudo apt-get install postgresql -y

sudo -H -u  postgres  createuser --createdb --username postgres --no-createrole --no-superuser --no-password  odoo17

sudo -H -u  postgres psql  -c  "ALTER USER odoo17 WITH SUPERUSER;"

sudo adduser --system --home=/opt/odoo17 --group odoo17
sudo apt-get install git
sudo chmod -R 777 /opt
cd /opt/odoo17
mkdir odoo
cd odoo
git clone https://www.github.com/odoo/odoo --depth 1 --branch 17.0 --single-branch
sudo apt-get install -y python3-venv
cd /opt/odoo17/
mkdir venv
cd venv
python3 -m venv odoo17
/opt/odoo17/venv/odoo17/bin/pip3 install psycopg2-binar
sudo apt install libpq-dev python3-dev -y
sudo chmod -R 777 /opt/odoo17/venv/odoo17/

sudo apt install -y libldap2-dev libssl-dev 
sudo apt-get install -y python3-dev libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev libldap2-dev build-essential libssl-dev libffi-dev libmysqlclient-dev libjpeg-dev libpq-dev libjpeg8-dev liblcms2-dev libblas-dev libatlas-base-dev

/opt/odoo17/venv/odoo17/bin/pip3 install -r /opt/odoo17/odoo/odoo/requirements.txt

cd /opt/odoo17/odoo/odoo
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo apt install -y xfonts-75dpi xfonts-base

apt --fix-broken install

sudo wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb
sudo dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb 
sudo apt install -f -y

sudo touch /etc/odoo17.conf
 sudo chmod 777 /etc/odoo17.conf

 sudo     cat > /etc/odoo17.conf << EOM
[options]
   ; This is the password that allows database operations:
   admin_passwd = admin
   db_host = False
   db_port = False
   db_user = odoo17
   db_password = False
   addons_path = /opt/odoo17/odoo/odoo/addons
   logfile = /var/log/odoo/odoo17.log
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


EOM
sudo mkdir -p /var/log/odoo
sudo chmod -R 777 /var/log/odoo
sudo touch /etc/systemd/system/odoo17.service
sudo chown root: /etc/systemd/system/odoo17.service
sudo chmod -R 777 /etc/systemd/system/odoo17.service
 sudo     cat > /etc/systemd/system/odoo17.service << EOM
[Unit]
   Description=Odoo17
   Documentation=http://www.odoo.com
   [Service]
   # Ubuntu/Debian convention:
   Type=simple
   User=odoo17
   ExecStart=/opt/odoo17/venv/odoo17/bin/python3 /opt/odoo17/odoo/odoo/odoo-bin -c /etc/odoo17.conf
   [Install]
   WantedBy=default.target

EOM
sudo systemctl daemon-reload
systemctl start odoo17
systemctl restart odoo17
echo "If there is any issues try removing proxyy_mode=True from /etc/odoo17.conf"
