[
  %{ for container in containers }
  {
    "name": "${container.name}-${environment}",
    "image": "${container.image}:${container.version}",
    "cpu": ${container.cpu},
    "memory": ${container.memory},
    "essential": ${container.essential},
    "portMappings": [
      {
        "containerPort": ${container.port},
        "hostPort": ${container.port},
        "protocol": "tcp"
      }
    ]%{ if length(container.environment_variables) > 0 },%{
    "environment": [
      %{ for env_key, env_value in container.environment_variables }
      { "name": "${env_key}", "value": "${env_value}" }%{ if env_key != keys(container.environment_variables)[-1] },%{ endif }
      %{ endfor }
    ]%{ endif },%{
    "mountPoints": [
      %{ for mount in container.mount_points }
      {
        "sourceVolume": "${mount.sourceVolume}",
        "containerPath": "${mount.containerPath}",
        "readOnly": ${mount.readOnly}
      }%{ if mount != container.mount_points[-1] },%{ endif }
      %{ endfor }
    ],
    "healthCheck": {
      "command": ["CMD-SHELL", "${container.health_check.command}"],
      "interval": ${container.health_check.interval},
      "timeout": ${container.health_check.timeout},
      "retries": ${container.health_check.retries}
    }
  }%{ if container != containers[-1] },%{ endif }
  %{ endfor }
]
