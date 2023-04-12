output "jenkins_url" {
  description = "AWS jenkins server url"
  value       = join("", ["http://", aws_instance.jenkins-server.public_dns, ":8080"])
}

output "sonarqube_url" {
  description = "AWS sonarqube server url"
  value       = join("", ["http://", aws_instance.sonarqube-server.public_dns, ":9000"])
}