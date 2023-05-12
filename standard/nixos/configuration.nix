# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  #boot.loader.systemd-boot.enable = true;
	boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.

  # Set your time zone.
 # TODO: Move this to another file {{{
	  time.timeZone = "America/Sao_Paulo";

	  # Select internationalisation properties.
	  i18n.defaultLocale = "en_US.UTF-8";

	  i18n.extraLocaleSettings = {
	    LC_ADDRESS = "pt_BR.UTF-8";
	    LC_IDENTIFICATION = "pt_BR.UTF-8";
	    LC_MEASUREMENT = "pt_BR.UTF-8";
	    LC_MONETARY = "pt_BR.UTF-8";
	    LC_NAME = "pt_BR.UTF-8";
	    LC_NUMERIC = "pt_BR.UTF-8";
	    LC_PAPER = "pt_BR.UTF-8";
	    LC_TELEPHONE = "pt_BR.UTF-8";
	    LC_TIME = "pt_BR.UTF-8";
	  };
  #}}}
  #users.mutableUsers = false;
  users.users = {
    # FIXME: Replace with your username
    # TODO: You can set an initial password for your user.
    # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
    # Be sure to change it (using passwd) after rebooting!
    nilan = {
    	#passwordHash = "$6$PI9zDSZsRE5ysWjy$oOa.2EKJUAROoAsQ1VZlpljS8Xt13SBMPdQjjbYZEvajOW6rsRKKF8aXO3ppYLwJe/y5TjuXEOwAs3otLq2MO.";
		 	#password = "default";
	    isNormalUser = true;
	    description = "nilan";
	    extraGroups = [ "networkmanager" "wheel" ];
	    #openssh.authorizedKeys.keys = [
      	# TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      #];
	    # packages = with pkgs; [
	      # firefox
	      # kate

	    # ];
    };
   
  };
  

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  # services.openssh = {
    # enable = true;
    # # Forbid root login through SSH.
    # permitRootLogin = "no";
    # # Use keys only. Remove if you want to SSH using password (not recommended)
    # passwordAuthentication = false;
  # };

    # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };
  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

	 # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  environment.systemPackages =  with pkgs; [
 		 #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
 		 #  wget
 		 git
 		 micro
 		 starship
 		 unstable.ruby_3_1
 		 unstable.crystal_1_7
 	 ];

  programs.starship = {
	  enable = true;
	  # Configuration written to ~/.config/starship.toml
	  settings = {
	    # add_newline = false;
			# format = ""$character"";
	    # character = {
	    #   success_symbol = "[➜](bold green)";
	    #   error_symbol = "[➜](bold red)";
	    # };
			# right_format = ""$all"";
	    # package.disabled = true;
	  };
  };
  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
