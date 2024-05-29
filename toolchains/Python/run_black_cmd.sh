black .

git_diff=$(echo $(git diff))
if [ ! -z "$git_diff" -a "$git_diff" != " " ]; then
    BOLD='\033[1m'
    NONE='\033[00m'
    echo -e "❌ ${BOLD}The following files have been modified after formatting. Please git commit the changes.${NONE}"
    echo $(git diff --name-only)
    exit 1
fi
echo "✅ All files are unchanged after formatting!"
exit 0
