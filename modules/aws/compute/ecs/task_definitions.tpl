[
  %{ for container in containers }
  {
    "name": "${container.name}-${env}",
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
    ]%{ if length(container.env_variables) > 0 },
    "env": [
      %{ for env_key, env_value in container.env_variables }
      { 
        "name": "${env_key}", 
        "value": "${env_value}" 
      }%{ if env_key != keys(container.env_variables)[-1] },%{ endif }
      %{ endfor }
    ]%{ endif },
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
