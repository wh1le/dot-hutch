{ pkgs, settings, ... }:
{

  i18n.extraLocaleSettings = {
    LC_ADDRESS = settings.defaultLocale;
    LC_IDENTIFICATION = settings.defaultLocale;
    LC_MEASUREMENT = settings.defaultLocale;
    LC_MONETARY = settings.defaultLocale;
    LC_NAME = settings.defaultLocale;
    LC_NUMERIC = settings.defaultLocale;
    LC_PAPER = settings.defaultLocale;
    LC_TELEPHONE = settings.defaultLocale;
    LC_TIME = settings.defaultLocale;
    LC_MESSAGES = settings.defaultLocale;
    LC_COLLATE = settings.defaultLocale;
    LANGUAGE = settings.defaultLocale;
    LC_ALL = settings.defaultLocale;
    LC_CTYPE = settings.defaultLocale;
  };

  i18n.extraLocales = settings.locales;
  i18n.defaultLocale = settings.defaultLocale;

  environment.systemPackages = with pkgs; [
    hunspellDicts.en_US
    hunspellDicts.pt_PT
    hunspellDicts.ru_RU

    nuspell
    hyphen
    hunspell
  ];
}
