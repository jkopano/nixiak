{ den, __findFile, ... }:
{
  den.aspects.hardware = {
    includes = [
      <hardware/audio>
      <hardware/battery>
      <hardware/bluetooth>
      <hardware/keyboard>
    ];
  };
}