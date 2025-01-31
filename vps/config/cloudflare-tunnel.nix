{ config, pkgs, ... }:

{
  # CloudFlare Tunnel
  services.cloudflared = {
    enable = true;
    user = "reika";
    tunnels = {
      "8ab93b55-aa2f-420d-a276-85d02d8f3ef7" = {
        default = "http_status:404";
	ingress = {
	  "audiobooks.reika.io" = "http://localhost:10081";
	  "glance.reika.io" = "http://localhost:10091";
	  "hoarder.reika.io" = "http://localhost:19025";
	  "monica.reika.io" = "http://localhost:10085";
	  "skywatch.reika.io" = "http://127.0.0.1:8000";
	  "skywatch-api.reika.io" = "http://127.0.0.1:5000";
	  "recipes.reika.io" = "http://localhost:10084";
	  "wallabag.reika.io" = "http://localhost:19013";
	};
	credentialsFile = "${config.users.users.reika.home}/.cloudflared/8ab93b55-aa2f-420d-a276-85d02d8f3ef7.json";
      };
    };
  };
}
