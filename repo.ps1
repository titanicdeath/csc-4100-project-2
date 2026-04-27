param(
    [string]$m
)

git add .

if (git diff --cached --quiet) {
    Write-Host "Nothing staged to commit."
    exit 0
}

$commitMessage = if ($m) {
    $m
} else {
    "Update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

git commit -m $commitMessage
git push