sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
 sudo     cat > /etc/nginx/sites-available/odoo.conf << EOM
server {
listen 80;
server_name <server_name>;

proxy_read_timeout 300000;
proxy_connect_timeout 300000;
proxy_send_timeout 300000;
# Add Headers for odoo proxy mode
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Real-IP $remote_addr;

# log
access_log /var/log/nginx/odoo.access.log;
error_log /var/log/nginx/odoo.error.log;

# Redirect requests to odoo backend server
location / {
proxy_redirect off;
proxy_pass http://127.0.0.1:8069;
}
location /longpolling {
proxy_pass http://127.0.0.1:8069;
}

# common gzip
gzip_types text/css text/less text/plain text/xml application/xml application/json application/javascript;
gzip on;

client_body_in_file_only clean;
client_body_buffer_size 32K;
client_max_body_size 500M;
sendfile on;
send_timeout 600s;
keepalive_timeout 300;
}

EOM
sudo ln -s /etc/nginx/sites-available/odoo.conf /etc/nginx/sites-enabled/odoo.conf
sudo service nginx restart
