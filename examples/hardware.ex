defmodule Hardware do
  @moduledoc false

  def buzz do
    buzzer = "/sys/class/leds/usr-buzzer/brightness"
    File.write(buzzer, "1")
    :timer.sleep(100)
    File.write(buzzer, "0")
  end

  def short_buzz do
    buzzer = "/sys/class/leds/usr-buzzer/brightness"
    File.write(buzzer, "1")
    :timer.sleep(50)
    File.write(buzzer, "0")
  end

  def read_light_sensor() do
    result = File.read("/sys/bus/iio/devices/iio:device0/in_illuminance_input")

    case result do
      {:ok, value} ->
        value
        |> String.replace("\n", "")
        |> String.to_integer()

      error ->
        error
    end
  end

  # TODO: 
  # - i2c not enabled atm
  # - configure i2c bus and device id

  def get_serial_number(target) do
    {:ok, i2c} = ATECC508A.Transport.I2C.init([])

    i2c
    |> NervesKey.default_info()
    |> Map.get(:manufacturer_sn)
  end

  def blink_led(color) do
    Delux.render(Delux.Effects.blink(color, 2))
  end

  def disable_leds() do
    Delux.render(Delux.Effects.off())
  end
end
