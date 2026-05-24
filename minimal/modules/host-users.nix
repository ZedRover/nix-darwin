{ ... } @ args:
#############################################################
#
#  Host & Users configuration
#
#############################################################
let
  name = "zeds-mac";
  username = "zed";
in
{
  networking.hostName = name;
  networking.computerName = name;
  system.defaults.smb.NetBIOSName = name;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
  };
}
