{ ... }: {
  security.pki.caCertificateBlacklist = [
    # CVE-2026-111943
    "Comodo AAA Services root"
  ];

  # test
  # curl https://dv-g3b-emudhra.we-have-a-problem.com/
  # curl https://dv-g3b-aaa-emudhra.we-have-a-problem.com/
}
