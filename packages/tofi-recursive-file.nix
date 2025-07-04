{
  writeShellApplication,
  tofi,
  fd,
}:
writeShellApplication {
  name = "tofi-recursive-file";
  runtimeInputs = [
    fd
    tofi
  ];
  text = ''
    # Starting directory
    DIR=$HOME
    if [[ -d $1 ]]; then
      DIR=$(realpath "$1")
      shift
    fi

    while true; do
      FILES=$(
        cd "$DIR" # Go to DIR so fd prints without prefix
        echo .. # Start with .. for navigation
        fd . -d5   # Print options
        echo .  # Last option is . to select folder
      )
      # Get selection from tofi
      SELECTED=$(tofi \
        --prompt-text="$\{DIR%/}/" \
        --require-match=false \
        --fuzzy-match=true \
        --num-results=0 \
        "$@" \
        <<< "$FILES")

      # Nothing was selected
      if [[ -z $SELECTED ]]; then
        exit
      fi

      DIR="$DIR/$SELECTED"
      if [[ ! -e $DIR ]]; then
        mkdir -p "''${DIR%/*}" # path without filename
      fi

      if [[ -d $DIR ]]; then
        DIR=$(realpath "$DIR")
      fi

      # File or current directory was selected
      if [[ -f $DIR || ! -e $DIR || $SELECTED == "." ]]; then
        echo "$DIR"
        exit
      fi
    done
  '';
}
