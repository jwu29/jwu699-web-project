#!/bin/bash
sudo systemctl start tomcat11.service
sudo systemctl enable tomcat11.service
sudo systemctl start httpd.service
sudo systemctl enable httpd.service