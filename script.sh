#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y ca-certificates curl nginx

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

app_dir="/opt/react-app"
rm -rf "$app_dir"
mkdir -p "$app_dir/src"

cat > "$app_dir/package.json" <<'JSON'
{
  "name": "pagina-inicio",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "build": "vite build"
  },
  "dependencies": {
    "@vitejs/plugin-react": "^4.3.4",
    "vite": "^6.0.5",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {}
}
JSON

cat > "$app_dir/index.html" <<'HTML'
<!doctype html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mi página</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
HTML

cat > "$app_dir/src/main.jsx" <<'JS'
import React from "react";
import { createRoot } from "react-dom/client";
import "./index.css";

function App() {
  return (
    <main>
      <p className="saludo">Hola, bienvenido</p>
      <h1>Mi página web</h1>
      <p>Este es un pequeño proyecto hecho con React.</p>
      <button type="button" onClick={() => alert("Gracias por visitar la página")}>
        Saludar
      </button>
    </main>
  );
}

createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
JS

cat > "$app_dir/src/index.css" <<'CSS'
:root {
  font-family: Arial, sans-serif;
  color: #253047;
  background: #f4efe7;
}

body {
  margin: 0;
}

main {
  max-width: 680px;
  margin: 12vh auto;
  padding: 3.5rem;
  background: #fffdf9;
  border-radius: 10px;
  box-shadow: 0 8px 24px rgb(68 55 38 / 12%);
}

h1 {
  margin: 0 0 1rem;
  color: #8d4b35;
  font-size: 2.5rem;
}

.saludo {
  margin: 0 0 0.75rem;
  color: #a56a45;
  font-size: 1.1rem;
}

button {
  margin-top: 1rem;
  padding: 0.7rem 1.2rem;
  border: 0;
  border-radius: 6px;
  color: white;
  background: #8d4b35;
  cursor: pointer;
  font-size: 1rem;
}

button:hover {
  background: #6f3828;
}
CSS

cd "$app_dir"
npm install
npm run build

rm -rf /var/www/html/*
cp -r dist/. /var/www/html/
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

ufw allow 80/tcp || true
iptables -I INPUT -p tcp --dport 80 -j ACCEPT || true

systemctl enable nginx
systemctl restart nginx
