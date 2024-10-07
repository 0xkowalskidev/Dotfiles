{ config, lib, pkgs, ... }:

{
  options.projects.container-orchestrator.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable dependencies for container orchestrator project";
  };

  config = lib.mkIf config.projects.container-orchestrator.enable {
    environment.systemPackages = with pkgs; [
      cni
      cni-plugins
    ];

    virtualisation.docker.enable = true;
    virtualisation.containerd.enable = true;
    virtualisation.containers.containersConf.cniPlugins = [
      pkgs.cni-plugins
    ];

    services.etcd.enable = true;

    environment.etc."cni/net.d/10-mynet.conflist".text = ''
       {
        "cniVersion": "1.0.0",
        "name": "mynet",
        "plugins": [
          {
            "type": "bridge",
            "bridge": "cni0",
            "isGateway": true,
            "ipMasq": true,
            "ipam": {
              "type": "host-local",
              "subnet": "10.22.0.0/16",
              "routes": [
                { "dst": "0.0.0.0/0" }
              ]
            }
          },
          {
            "type": "portmap",
            "capabilities": {
              "portMappings": true
            },
            "snat": true
          }
        ]
      }
    '';
  };
}
