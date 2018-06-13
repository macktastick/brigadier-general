# README

## How does this work?

The script that counts and tracks vote totals is in lib/tasks/scan.rake. Every
minute, cron runs this script on the production server. The script grabs the hot
100 posts from the subreddit in question via the Reddit API. Post meta data and
vote observations are stored in a MySQL DB (any other would work as well).

This same script checks if currently observed vote data for a post violates any
of the subreddit's filters for what's considered irregular. These exact filter
thresholds can be set on a per subreddit basis. The values are stored in
config/subreddits.yml, but not stored in version control (these should be
considered sensitive information even if this code is made public).

## Utility Scripts

lib/tasks/brigade.rake - for intentionally VMing a post. Intended to be used on
restricted subreddits for testing purposes.

lib/tasks/reddit_sentinel.rake - prototype of a daemon that listens for comments
on reddit.com with magic phrases of interest. Intended to be used to detect
x-linking in Reddit comments. Works, but couple bugs.  
