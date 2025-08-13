{
  genOpts = health-cmd: [
    "--cap-drop=all"
    "--health-cmd=${health-cmd}"
    "--health-start-period=1m"
    "--health-interval=5m"
    "--health-timeout=10s"
    "--health-retries=3"
  ];
}
