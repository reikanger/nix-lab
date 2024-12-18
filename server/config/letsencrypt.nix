{ config, pkgs, ... }:

{
  # ACME Lets Encrypt SSL Certificate
  security.acme = {
    acceptTerms = true;
    defaults.email = "ryan.eikanger@runbox.com";

    certs."reika.io" = {
      domain = "reika.io";
      extraDomainNames = [ "*.reika.io" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      credentialFiles = {
        "CLOUDFLARE_DNS_API_TOKEN_FILE" = "/root/cloudflare-api-token";
        "CLOUDFLARE_EMAIL_FILE" = "/root/cloudflare-email";
      };
      dnsPropagationCheck = true;
      reloadServices = [ "nginx" ];
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
