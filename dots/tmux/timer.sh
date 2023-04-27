#!/bin/bash

CONF_FOLDER="$HOME/.config"
TIMER_FOLDER="$CONF_FOLDER/worktimer"
ARCHIVE_FOLDER="$TIMER_FOLDER/archive"
TODAY_FILE="$TIMER_FOLDER/today"
DB_SCR=""

err () {
  echo $@ ;
  exit 1
}

dbg () {
  [ -n "$DB_SCR" ] || echo $@ ;
}

current-time-ms(){
  date +%s;
}

daylog-archive(){
  tiemstamp_create=$(date -d @$(awk 'NR==1{print $1}' $TODAY_FILE) +%H:%M-[%d-%m-%y])
  tiemstamp_end=$(date -d @$(awk 'END{print $1}' $TODAY_FILE) +%H:%M-[%d-%m-%y])
  echo "$tiemstamp_create-$tiemstamp_end"
}

ensure-folders ()
{
  [ -d $CONF_FOLDER    ] || err   "Folder $CONF_FOLDER not exist" ;
  [ -d $TIMER_FOLDER   ] || mkdir $TIMER_FOLDER
  [ -d $ARCHIVE_FOLDER ] || mkdir $ARCHIVE_FOLDER
}

calculate_seconds_today() {
  awk -v crnt_time=`current-time-ms` '\
    NR==1{gl_offset=$1; offset=$1; acc=0; rest=0;ending}  \
    NR%2==1 {if ("f" == $2) {ending=1} rest = rest + ($1 - offset);offset=$1} \
    NR%2==0 { if ("f" == $2) {edning=1} acc = acc + ($1 - offset); offset=$1} \
    END{if(ending != 1 && NR%2==1) {acc+=(crnt_time-offset)}  print acc}' \
  $TODAY_FILE
}

status-tmux ()
{
  echo "tmux stuff" `status`
}

status ()
{
  [ -e $TODAY_FILE ] && date -u -d @`calculate_seconds_today` +%H:%M || echo "00:00"
}

start ()
{
  [ -e $TODAY_FILE ] && echo "$(current-time-ms) r" >> $TODAY_FILE || echo "$(current-time-ms) s" > $TODAY_FILE 
  dbg "Todo: create start method"
}

finsih ()
{
  [ -e $TODAY_FILE ] && echo "$(current-time-ms) f" >> $TODAY_FILE mv $TODAY_FILE $ARCHIVE_FOLDER/$(daylog-archive)
}
pause ()
{
  [ -e $TODAY_FILE ] && echo "$(current-time-ms) r" >> $TODAY_FILE || echo "$(current-time-ms) s" > $TODAY_FILE 
}

help_use ()
{
        echo -e "Usage:";
        echo -e "\t--start,\t-s\t Start a day timer.";
        echo -e "\t--tmux-status,\t-T\t Information in a format compatible with my tmux statusline."
        echo -e "\t--finish,\t-f\t Finish day."
        echo -e "\t--pause,\t-p\t Add a rest checkpoint."
}

ensure-folders
if [[ $# == "0" ]]; then 
  help_use
else
  for arg in "$@";do
    case "$arg" in
      "--tmux-status" | "-T" )
        status-tmux
        ;;
      "--status" | "-S" )
        status
        ;;
      "--start" | "-s" )
        start
        ;;
      "--finish" | "-f" )
        finsih
        ;;
      "--pause" | "-p" )
        pause
        ;;
      *)
        help_use
        # exit 0
        ;;
    esac
  done
fi
