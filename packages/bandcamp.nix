# also tried out beets but didn't end up using it
{
  imagemagick,
  lib,
  opus-tools,
  unzip,
  writers,
  python314,
}:
writers.makeScriptWriter { interpreter = "${python314}/bin/python"; } "/bin/bandcamp-import"
  # {
  #   flakeIgnore = [
  #     "E501"
  #     "E121"
  #   ];
  # }
  ''
    import sys
    import tempfile
    import subprocess
    from pathlib import Path
    import re
    import os

    unzip = "${lib.getExe unzip}"
    opusenc = "${lib.getExe' opus-tools "opusenc"}"
    magick = "${lib.getExe imagemagick}"


    p = re.compile(r"(.+) - (.+) - (\d+) (.+).wav")

    if len(sys.argv) != 3 or \
      not os.path.exists(sys.argv[1]) or \
      not sys.argv[2].endswith(".zip"):
        print(f"Usage: {sys.argv[0]} storage_dir bandcamp_album_download.zip")
        exit(1)

    with tempfile.TemporaryDirectory() as tmpdirname:
        tmp = Path(tmpdirname)
        subprocess.check_call([unzip, Path(sys.argv[2]).expanduser().absolute(), "-d", tmp])

        files = [x for x in os.listdir(tmp) if x.endswith(".wav")]

        for x in files:
            if not p.match(x):
                print(f"Filename '{x}' does not match format. Aborting")
                exit(1)

        artist, album, _, _ = p.match(files[0]).groups()
        path = Path("/mnt/music") / artist / album
        path.mkdir(parents=True, exist_ok=True)

        cover = [x for x in tmp.iterdir() if x.stem == "cover"][0]
        cover.copy_into(path)
        for f in files:
            artist, album, n, title = p.match(str(f)).groups()
            subprocess.check_call([
              opusenc,
              "--title", title,
              "--artist", artist,
              "--album", album,
              "--tracknumber", n,
              tmp / f,
              path / f"{int(n):02} {title}.opus"
            ])
  ''
