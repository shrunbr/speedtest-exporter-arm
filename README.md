# Prometheus Speedtest Exporter - ARM Version
This allows you to run the [speedtest_exporter](https://github.com/nlamirault/speedtest_exporter) on an ARM based processor within docker. Currently this dockerfile defaults to arm32v7. You may change it by modifying the "GOARM" variable within the file to your desired version.

## Creating the container
This image can be pulled from [Docker Hub](https://hub.docker.com/r/shrunbr/speedtest-exporter-arm). Full build line is below.

    docker run -d --name speedtest shrunbr/speedtest-exporter-arm

If you need to expose the container port tcp/9112 to the host run

    docker run -d --name speedtest -p 9112:9112 shrunbr/speedtest-exporter-arm

## Using within Prometheus
This assumes: 

 - You have Prometheus running (somewhere)
 - Your Prometheus server is able to connect to your container network or host

After you have spun up the image via docker you need to go to your Prometheus server and modify the `config.yml` file and add a new job to scrape the metrics from the container we created. The speedtest only runs when the metrics are scraped so a longer interval than your global is recommended.

      - job_name: 'speedtest_metrics'
        scrape_interval: 15m
        static_configs:
          - targets: ['CONTAINER_IP:9112']
Replace `CONTAINER_IP` with the IP of your container or the IP of your host if you're exposing the port that way. Modify the `scrape_interval` as needed. If you wish to use your global scrape interval just remove the variable under `job_name`