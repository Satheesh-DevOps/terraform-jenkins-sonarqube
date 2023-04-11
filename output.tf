output "jenkins_url" {
  description = "AWS jenkins server url"
  value       = join("", ["http://", aws_instance.jenkins-server.public_dns, ":8080"])
}