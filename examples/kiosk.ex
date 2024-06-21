defmodule Monitor.OS.Kiosk do
  @moduledoc false
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    setup_xdg_runtime_dir(opts[:dir])
    setup_udev()

    children = [
      seatd(),
      weston(opts[:dir])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def seatd do
    Supervisor.child_spec(
      {MuonTrap.Daemon,
       [
         "seatd",
         [],
         []
       ]},
      id: Monitor.OS.Kiosk.Seatd,
      restart: :permanent
    )
  end

  def weston(dir) do
    Supervisor.child_spec(
      {MuonTrap.Daemon,
       [
         "weston",
         ["-B", "drm", "--config=#{Monitor.config([:config_dir])}weston.ini"],
         [env: [{"XDG_RUNTIME_DIR", "#{dir}/nerves_weston"}]]
       ]},
      id: Monitor.OS.Kiosk.Weston,
      restart: :permanent
    )
  end

  def navigate_to(url) do
    dir = Path.join(Monitor.config([:data_dir]), "nerves_weston")
    :os.cmd(~c"killall cog")

    spawn(fn ->
      MuonTrap.cmd(
        "cog",
        ["--bg-color=#cad6d200", "--enable-developer-extras=1", url],
        env: [
          {"XDG_RUNTIME_DIR", dir},
          {"COG_PLATFORM_FDO_VIEW_FULLSCREEN", "1"},
          {"WAYLAND_DISPLAY", "wayland-1"},
          {"WEBKIT_INSPECTOR_SERVER", "0.0.0.0:9224"},
          {"WEBKIT_INSPECTOR_HTTP_SERVER", "0.0.0.0:9222"}
        ]
      )
    end)
  end

  def start_remote_debugger() do
    System.cmd("socat", ["tcp-listen:9223,fork", "tcp:localhost:9222"])
  end

  def setup_xdg_runtime_dir(path) do
    File.mkdir(path)
    File.mkdir("#{path}/nerves_weston")
    stat = File.stat!(path)
    File.write_stat!(path, %{stat | mode: 33_216})
  end

  def setup_udev do
    :os.cmd(~c"udevd -d")
    :os.cmd(~c"udevadm trigger --type=subsystems --action=add")
    :os.cmd(~c"udevadm trigger --type=devices --action=add")
    :os.cmd(~c"udevadm settle --timeout=30")
    :os.cmd(~c"modprobe -r vc4")
    :os.cmd(~c"modprobe vc4")
  end
end
