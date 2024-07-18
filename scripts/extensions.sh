cd ~/Downloads/Songs/
for ext in mp3 wav flac; do 
  ls -i *.$ext 2>/dev/null
done | awk '{print $1}'
