{...} @ args:
#############################################################
#
#  Host & Users configuration
#
#############################################################
let
  # TODO change this to your hostname & username
  name = "zeds";
  username = "zed";
in {
  networking.hostName = name;
  networking.computerName = name;
  system.defaults.smb.NetBIOSName = name;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
  };
}
