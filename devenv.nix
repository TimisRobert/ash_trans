{
  config,
  pkgs,
  ...
}: {
  env.MIX_HOME = "${config.env.DEVENV_STATE}/.mix";

  packages = [
    pkgs.beam.packages.erlang_27.elixir_1_17
  ];
}
