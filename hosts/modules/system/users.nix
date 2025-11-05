{ ... }:

{
  time.timeZone = "Europe/Lisbon";

  users.users.wh1le = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqwaJDbwBjkVOyBC987h8Lv46tC7ICr9EMOVS3/4bTp5TrWye62umGztdU/Tl9/sKZ05bLwm0VoHU6VVYbAv8PdLP9ky3U0ySF7pTgKRQaMi+7A38ZrXh6rxxD0udlvKp3o6a5eEImnU5Y2GI72XHsg7f2n5gcjO+IgB8+yoVSAZbZkCww3j+1xrTa9ehYNRKBgJOB4g0v8tMDSmLyKC5J5pnVoL+/Gm/OHmIADSkzitk5J7mm/3UmJprWdU9Hd06dmgehK7x/zLhdSyDofS/BUYsVwv5sEjO+8dtRr2Ull/YlFhdBfM+tgRmr/MCIq1F0+8XpnaPv1wr3LdPf/ZJNTveWeEaa3uFbRmaOdp1eT7rwFgJbtyHJyPpRYM0b2QXfKBGqFZly5kRX7wFyqvCxhE0OpcLq7Lbi1O/9bDbeCmMHmBW1A92mSjdWJ7OulRbApOMI9c3LrrRZCpHRhYYi/UWmjxpXDaJ4yrLDWZukIpvf0zs+nzBYgqO0tsZRYXs= nmiloserdov@MBP-de-mbp.home"
    ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "tss"
      "plugdev"
    ];
  };
}
