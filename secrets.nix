let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfcOdH0DX1wM+1UvZ3nBeKuGLyXv+TcHxFyONUaxhhb josh@sparrowhawk"
  ];

  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBQmOwtu8jQ85x1ulOnvXduq0GxwZNLk/wP91aY0D9Zl" # radagast
  ];

  all-keys = users ++ systems;
in { "secrets/radagast-acme-env.age".publicKeys = all-keys; }
