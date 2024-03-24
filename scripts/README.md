# Automation Scripts

Three scripts aimed at automating the process of scheduling, running, and managing the news-please scraping process.

## Shell Script: invoke_news_please.sh

+ This script facilitates the execution of the news-please command as a background process to be able to continue the script as it won't wait for the user actions and by default, this process won't end **(running forever)** 
+ The script then waits for 10 minutes to allow the news-please scraper to collect news data.
+ After the specified duration, the script collects the Process IDs (PIDs) of all news-please processes and kills them all.

## Systemd Service: invoke_news_please.service

+ This service unit is configured to execute the invoke_news_please.sh script as a single-shot operation.
+ It ensures the seamless execution of the script within the systemd environment, providing reliability and manageability.

## Systemd Timer: invoke_news_please.timer

+ The timer unit schedules the execution of the invoke_news_please.service at regular intervals of every 5 hours.
+ By automating the execution timing, the timer enhances the efficiency of news collection while minimizing manual intervention.
