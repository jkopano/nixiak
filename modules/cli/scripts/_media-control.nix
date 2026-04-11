{
  lib,
  pkgs,
  config,
  ...
}:
let
  playerctl = lib.getExe pkgs.playerctl;
in
pkgs.writeShellScriptBin "media-control" ''
  #!${pkgs.bash}/bin/bash

  bar_color="#F0C6C6"
  volume_step=5
  mic_volume_step=5

  # Gets the default sink (speaker) volume
  function get_volume {
    ${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | ${pkgs.gnugrep}/bin/grep -Po '[0-9]{1,3}(?=%)' | ${pkgs.coreutils}/bin/head -1
  }

  # Gets the default sink mute status
  function get_mute {
    ${pkgs.pulseaudio}/bin/pactl get-sink-mute @DEFAULT_SINK@ | ${pkgs.gnugrep}/bin/grep -Po '(?<=Mute: )(yes|no)'
  }

  # Gets the default source (microphone) volume
  function get_mic_volume {
    ${pkgs.pulseaudio}/bin/pactl get-source-volume @DEFAULT_SOURCE@ | ${pkgs.gnugrep}/bin/grep -Po '[0-9]{1,3}(?=%)' | ${pkgs.coreutils}/bin/head -1
  }

  # Gets the default source mute status
  function get_mic_mute {
    ${pkgs.pulseaudio}/bin/pactl get-source-mute @DEFAULT_SOURCE@ | ${pkgs.gnugrep}/bin/grep -Po '(?<=Mute: )(yes|no)'
  }

  # Returns appropriate volume icon based on volume level and mute status
  function get_volume_icon {
    volume=$1
    mute=$2
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ]; then
      echo "Muted"
    elif [ "$volume" -lt 5 ]; then
      echo " "
    elif [ "$volume" -le 35 ]; then
      echo " "
    elif [ "$volume" -lt 70 ]; then
      echo " "
    else
      echo " "
    fi
  }

  # Returns appropriate microphone icon based on volume level and mute status
  function get_mic_icon {
    volume=$1
    mute=$2
    if [ "$mute" == "yes" ] || [ "$volume" -eq 0 ]; then
      echo " "
    else
      echo " "
    fi
  }

  # Displays a notification with given icon, volume, and title
  function show_notif {
    icon=$1
    volume=$2
    title=$3
    ${pkgs.dunst}/bin/dunstify -i audio-volume-muted-blocking -t 1000 -r 2000 -u normal "$icon $title $volume%" -h int:value:"$volume" -h string:hlcolor:$bar_color
  }

  Control="YoutubeMusic"

  case $1 in
    --mpd | -M | -m)
      Control="MPD"
      shift 1
      ;;
    *)
      [ -n "$(${pkgs.procps}/bin/pgrep youtube-music)" ] && Control="YoutubeMusic"
      ;;
  esac

  # Here the cover image will be saved.
  Cover=/tmp/cover.png
  # if cover not found in metadata use this instead
  bkpCover=${config.xdg.configHome}/bspwm/src/assets/fallback.webp
  # mpd music directory for mpd clients.
  mpddir=~/Music
  LAST_SONG_FILE="/tmp/last_song.txt"

  case $Control in
    MPD)
      case $1 in
        --next)
          ${pkgs.mpc}/bin/mpc -q next
          ;;
        --previous)
          ${pkgs.mpc}/bin/mpc -q prev
          ;;
        --toggle)
          ${pkgs.mpc}/bin/mpc -q toggle
          ;;
        --stop)
          ${pkgs.mpc}/bin/mpc -q stop
          ;;
        --title)
          title=$(${pkgs.mpc}/bin/mpc -f %title% current)
          echo "''${title:-Play Something}"
          ;;
        --artist)
          artist=$(${pkgs.mpc}/bin/mpc -f %artist% current)
          echo "''${artist:-No Artist}"
          ;;
        --status)
          status=$(${pkgs.mpc}/bin/mpc status | ${pkgs.gnused}/bin/sed -En '2s/.*\[([^]]*)\].*/\u\1/p')
          echo "''${status:-Stopped}"
          ;;
        --player)
          echo "$Control"
          ;;
        --cover)
          current_song=$(${pkgs.mpc}/bin/mpc current -f "%title%-%artist%")
          last_song=""
          [ -f "$LAST_SONG_FILE" ] && last_song=$(${pkgs.coreutils}/bin/cat "$LAST_SONG_FILE")

          if [ "$current_song" != "$last_song" ] || [ ! -f "$Cover" ]; then
            ${pkgs.ffmpeg}/bin/ffmpeg -i "$mpddir/$(${pkgs.mpc}/bin/mpc current -f %file%)" "$Cover" -y >/dev/null 2>&1 || ${pkgs.coreutils}/bin/cp "$bkpCover" "$Cover"
            echo "$current_song" >"$LAST_SONG_FILE"
          fi

          echo "$Cover"
          ;;
        nccover)
          ${pkgs.ffmpeg}/bin/ffmpeg -i "$mpddir/$(${pkgs.mpc}/bin/mpc current -f %file%)" "$Cover" -y >/dev/null 2>&1 || ${pkgs.coreutils}/bin/cp "$bkpCover" "$Cover"
          ;;
        --position)
          position=$(${pkgs.mpc}/bin/mpc status %currenttime%)
          echo "''${position:-0:00}"
          ;;
        --positions)
          positions=$(${pkgs.mpc}/bin/mpc status %currenttime% | ${pkgs.gawk}/bin/awk -F: '{print ($1 * 60) + $2}')
          echo "''${positions:-0}"
          ;;
        --length)
          length=$(${pkgs.mpc}/bin/mpc status %totaltime%)
          echo "''${length:-0:00}"
          ;;
        --lengths)
          lengths=$(${pkgs.mpc}/bin/mpc status %totaltime% | ${pkgs.gawk}/bin/awk -F: '{print ($1 * 60) + $2}')
          echo "''${lengths:-0}"
          ;;
        --shuffle)
          shuffle=$(${pkgs.mpc}/bin/mpc status | ${pkgs.gnused}/bin/sed -n '3s/.*random: \([^ ]*\).*/\1/p' | ${pkgs.gnused}/bin/sed 's/.*/\u&/')
          echo "''${shuffle:-Off}"
          ;;
        --loop)
          loop=$(${pkgs.mpc}/bin/mpc status | ${pkgs.gnused}/bin/sed -n '3s/.*repeat: \([^ ]*\).*/\1/p' | ${pkgs.gnused}/bin/sed 's/.*/\u&/')
          echo "''${loop:-Off}"
          ;;
      esac
      ;;
    *)
      case $1 in
        --vol-up)
          if [ "$(get_volume)" -ge 100 ]; then exit; fi
          ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ 0
          ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
          show_notif "$(get_volume_icon "$(get_volume)" "$(get_mute)")" "$(get_volume)" "Volume"
          ;;
        --vol-down)
          ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
          show_notif "$(get_volume_icon "$(get_volume)" "$(get_mute)")" "$(get_volume)" "Volume"
          ;;
        --vol-mute)
          ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
          show_notif "$(get_volume_icon "$(get_volume)" "$(get_mute)")" "$(get_volume)" "Volume"
          ;;
        --mic-up)
          if [ "$(get_mic_volume)" -ge 100 ]; then exit; fi
          ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ 0
          ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +$mic_volume_step%
          show_notif "$(get_mic_icon "$(get_mic_volume)" "$(get_mic_mute)")" "$(get_mic_volume)" "Mic"
          ;;
        --mic-down)
          ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -$mic_volume_step%
          show_notif "$(get_mic_icon "$(get_mic_volume)" "$(get_mic_mute)")" "$(get_mic_volume)" "Mic"
          ;;
        --mic-mute)
          ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle
          show_notif "$(get_mic_icon "$(get_mic_volume)" "$(get_mic_mute)")" "$(get_mic_volume)" "Mic"
          ;;
        --next)
          ${playerctl} --player="$Control" next
          ;;
        --previous)
          ${playerctl} --player="$Control" previous
          ;;
        --toggle)
          ${playerctl} --player="$Control" play-pause
          ;;
        --stop)
          ${playerctl} --player="$Control" stop
          ;;
        --title)
          title=$(${playerctl} --player="$Control" metadata --format "{{title}}")
          echo "''${title:-Play Something}"
          ;;
        --artist)
          artist=$(${playerctl} --player="$Control" metadata --format "{{artist}}")
          echo "''${artist:-No Artist}"
          ;;
        --status)
          status=$(${playerctl} --player="$Control" status)
          echo "''${status:-Stopped}"
          ;;
        --player)
          echo "$Control"
          ;;
        --cover)
          current_song="$(${playerctl} --player="$Control" metadata --format '{{title}}-{{artist}}')"
          last_song=""
          [ -f "$LAST_SONG_FILE" ] && last_song=$(${pkgs.coreutils}/bin/cat "$LAST_SONG_FILE")

          if [ "$current_song" != "$last_song" ] || [ ! -f "$Cover" ]; then
            albumart="$(${playerctl} --player="$Control" metadata mpris:artUrl)"
            art_url=$(${playerctl} --player="$Control" metadata mpris:artUrl)
            if [ -n "$art_url" ]; then
              albumart="$art_url"
              ${pkgs.curl}/bin/curl -s "$albumart" --output "$Cover"
            else
              ${pkgs.coreutils}/bin/cp "$bkpCover" "$Cover"
            fi
            echo "$current_song" >"$LAST_SONG_FILE"
          fi

          echo "$Cover"
          ;;
        --position)
          position=$(${playerctl} --player="$Control" position --format "{{ duration(position) }}")
          echo "''${position:-0:00}"
          ;;
        --positions)
          positions=$(${playerctl} --player="$Control" position | ${pkgs.gnused}/bin/sed 's/..\{6\}$//')
          echo "''${positions:-0}"
          ;;
        --length)
          length=$(${playerctl} --player="$Control" metadata --format "{{ duration(mpris:length) }}")
          echo "''${length:-0:00}"
          ;;
        --lengths)
          lengths=$(${playerctl} --player="$Control" metadata mpris:length | ${pkgs.gnused}/bin/sed 's/.\{6\}$//')
          echo "''${lengths:-0}"
          ;;
        --shuffle)
          shuffle=$(${playerctl} --player="$Control" shuffle)
          echo "''${shuffle:-Off}"
          ;;
        --loop)
          loop=$(${playerctl} --player="$Control" loop)
          echo "''${loop:-None}"
          ;;
      esac
      ;;
  esac 2>/dev/null
''
